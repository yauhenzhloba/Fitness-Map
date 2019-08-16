//
//  SettingsTeamViewController.swift
//  YogaFit
//
//  Created by EUGENE on 8/4/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class SettingsTeamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var backgroundViewOutlet: UIView!
    
    
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var subtitleTextViewOutlet: UITextView!
    
    
    @IBOutlet weak var tagTextFieldOutlet: UITextField!
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var takeTeamTag = ""
    var teamName = ""
    var teamSubtitle = ""
    var takeTeamUid = ""
    var teamLeader = Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkTeamTag()
    }
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        super.viewDidLoad()
        //self.checkTeamTag()
        self.cornerLayers()
        self.subtitleTextViewHeightsParametrs()
        // Do any additional setup after loading the view.
        
        // tap subtitle tap tag
        //let tapSubtitle: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showChangeSubtitleVC))
        //self.subtitleTextFieldOutlet.addGestureRecognizer(tapSubtitle)
        let tapTag: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showChangeTagVC))
        self.tagTextFieldOutlet.addGestureRecognizer(tapTag)
        
        let tapKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapKeyboard)
        
        
    }
    
    
    
    func checkTeamTag(){
        
        self.tagTextFieldOutlet.text = self.takeTeamTag
        
    }
    
    func subtitleTextViewHeightsParametrs(){
        
        
        self.subtitleTextViewOutlet.delegate = self
        self.subtitleTextViewOutlet.isScrollEnabled = false
        textViewDidChange(subtitleTextViewOutlet)
        
    }
    
    func cornerLayers(){
        
        //self.nameTextFieldOutlet.setGrayBottomBorder()
        //self.subtitleTextFieldOutlet.setGrayBottomBorder()
        //self.tagTextFieldOutlet.setGrayBottomBorder()
        self.backgroundViewOutlet.layer.cornerRadius = 11
        
        
        
    }

    @objc func showChangeSubtitleVC(){
        
        print("show chenge subtitle")
        
        
    }
    
    @objc func showChangeTagVC(){
        
        print("show chenge tag")
        
        
        guard let vc: ChangeTeamTagVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changeTeamTagVC") as? ChangeTeamTagVC else {
            
            print("View controller could not be instantiated")
            return
        }
        //vc.self.passwordFromFirstController = passwordLabel.text
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        self.createTeamDataWithImage()
        //dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //self.checkInternetConnection()
        
        if textField == self.nameTextFieldOutlet {  // OR with Tag like textfield.tag == 45
            
            
            if self.nameTextFieldOutlet.text!.count <= 30 {
                
                
                
            }else{
                
                self.nameTextFieldOutlet.setRedBottomBorder()
            }
            
            //add check email in Firebase func
        } else {
            print("else")
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    
    @IBAction func chengeImageAction(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            
//            if imagePicked == 1 {
//                imageView1.image = pickedImage
//            } else if imagePicked == 2 {
//                imageView2.image = pickedImage
//            }
            
            self.teamImageView.image = selectedImage
            //self.newImage = 1
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        //self.newImage = 0
        dismiss(animated: true, completion: nil)
    }
    
    
    func createTeamDataWithImage(){
        
//        UIView.animate(withDuration: 0.4){
//            self.blackViewForLoadIcon.alpha = 1
//        }
//
//        UIView.animate(withDuration: 0.4){
//            self.btnSaveOutlet.isEnabled = false
//        }
//        UIView.animate(withDuration: 0.4){
//            self.btnCancelOutlet.isEnabled = false
//        }
        
//
//        self.userName = self.userNameTextField.text!
//        self.town = self.townField.text!
//        self.bio = self.bioField.text!
        
//        let getIndex = sexSegmented.selectedSegmentIndex
//        if getIndex == 0 {
//            self.sex = "Male"
//        }
//        if getIndex == 1 {
//            self.sex = "Female"
//        }
        
        
         takeTeamTag = self.tagTextFieldOutlet.text!
         teamName = self.nameTextFieldOutlet.text!
         teamSubtitle = subtitleTextViewOutlet.text
        
        
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("team_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.teamImageView.image!) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }else{
                    
                    storageRef.downloadURL { (url, error) in
                        guard let profileNewImageUrl = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                       
                        let teamUid = Database.database().reference().child("teams").childByAutoId()
                        teamUid.setValue(["teamTag": self.takeTeamTag, "teamName": self.teamName, "teamSubtitle":  self.teamSubtitle, "teamImageUrl": profileNewImageUrl.absoluteString, "teamLeaderUid": self.teamLeader])
                        
                        Database.database().reference().child("users").child(self.teamLeader!).updateChildValues(["teamUid": teamUid.key])
                        
                        
                    }
                    
                    //                    if let profileNewImageUrl = metadata?.absoluteString {
                    //
                    //                        Database.database().reference().child("users").child(self.uid!).setValue(["username": self.userName, "email": self.email, "profileImageUrl":  profileNewImageUrl, "sex": self.sex, "town": self.town, "bio": self.bio])
                    //                    }
                    
                    
                    
                    
                    let alertController = UIAlertController(title: "Saved", message: "Sucsessful", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                        print("You've pressed default");
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardControllerId")
                    // self.present(loginController, animated: true, completion: nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //show window
                    appDelegate.window?.rootViewController = loginController
                }
                
                
            })
        }
        
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
extension UITextField {
    func setGreyBottomSettingsView() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setRedBottomSettingsView() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension SettingsTeamViewController: UITextViewDelegate {
    
    func textViewDidChange(_ subtitleTextViewOutlet: UITextView) {
        //
        let size = CGSize(width: self.subtitleTextViewOutlet.frame.width, height: .infinity)
        let estimateSize = self.subtitleTextViewOutlet.sizeThatFits(size)
        //self.subtitleTextViewOutlet.translatesAutoresizingMaskIntoConstraints = false
        self.textViewHeightConstraint.constant = estimateSize.height
        self.view.layoutIfNeeded()
        
        
    }
    
    
    
    
}
