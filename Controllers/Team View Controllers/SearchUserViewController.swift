//
//  SearchUserViewController.swift
//  YogaFit
//
//  Created by EUGENE on 8/5/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase


class SearchUserViewController: UIViewController {


    
    @IBOutlet weak var inputTextFieldSearch: UITextField!
    var myUsernameCode = ""
    let uid = Auth.auth().currentUser?.uid
    var foundUserNameUid = ""
    var teamUid = ""
    var leaderUid = ""
    var teamName = ""
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var viewMainUser: UIView!
    
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileUsernameLabel: UILabel!
    
    override func viewDidLoad() {
        self.viewMainUser.alpha = 0
        print("leaderUid and teamUid")
        print(self.leaderUid)
        print(self.teamUid)
        super.viewDidLoad()
        self.getMyUsernameCode()
        self.inputTextFieldSearch.addTarget(self, action: #selector(SearchUserViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let tapKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapKeyboard)
        
    }
    
    @IBAction func inviteButtonAction(_ sender: Any) {
        let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
        Database.database().reference().child("teamShip").child(foundUserNameUid).setValue(["teamUid": self.teamUid, "leaderUid": self.leaderUid, "status": "0", "timestamp": timestamp, "teamName": self.teamName])
        
    }
    
    
    func getMyUsernameCode(){
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("func check usernameCode")
            print(snapshot)
            if let value = snapshot.value as? [String: AnyObject]  {
            
                self.myUsernameCode = (value["usernameCode"] as? String)!
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(self.inputTextFieldSearch.text!)
        
            if self.inputTextFieldSearch.text != "" {
                self.searchUserInFirebase()
            } else {
                print("Empty text field")
                    }
    }
    
    func searchUserInFirebase(){

        
        
        Database.database().reference().child("usernames").child(inputTextFieldSearch.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.key)
            
            
            
            
            
            if snapshot.key != self.myUsernameCode {
                print("Get new user")
                self.viewMainUser.alpha = 1
                            if let value = snapshot.value as? [String: AnyObject]  {
                                
                                let foundUserUid = (value["user"] as? String)!
                                print("USER")
                                print(foundUserUid)
                                
                                
                                
                                Database.database().reference().child("users").child(foundUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
                                if let value = snapshot.value as? [String: AnyObject]  {
                                    
                                    self.foundUserNameUid = snapshot.key
                                    print("found user uid")
                                    print(snapshot.key)
                                    
                                    
                                    
                                    self.profileNameLabel.text = value["username"] as? String
                                    let profileUsernameString = value["usernameCode"] as? String
                                    //self.userNameCode =
                                    self.profileUsernameLabel.text =  "@" + profileUsernameString!
                                    
                                    // if let checkUserTeam = value["teamUid"] as? String 
                                    
                                    
                                    
                                    if let checkUrl = (value["profileImageUrl"] as? String)
                                    {
                                        DispatchQueue.main.async {
                                            self.profileImage.loadImageUsingCatchWithUrlString(urlString: checkUrl)
                                            
                                        }
                                    } else {
                                        self.profileImage.image = nil
                                    }
                                    
                                    
                                
                                    }
                                    
                                }) { (error) in
                                    
                                    print(error.localizedDescription)
                                }
                                    
                                
                
                            }else{
                                
                                print("user not found")
                                self.foundUserNameUid = ""
                                self.viewMainUser.alpha = 0
                                
                }
                
            } else {
                print("Found my name")
                self.foundUserNameUid = ""
                self.viewMainUser.alpha = 0
            }
//            if let value = snapshot.value as? [String: AnyObject]  {
//
//                self.myUsernameCode = (value["usernameCode"] as? String)!
//
//            }
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}






