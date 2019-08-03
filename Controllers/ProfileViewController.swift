//
//  ProfileViewController.swift
//  YogaFit
//
//  Created by EUGENE on 8/2/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    var transferUid = ""
    let currentUid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var mainProfileImageView: UIImageView!
    
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    @IBOutlet weak var buttonSendMessageOutlet: UIButton!
    
    @IBOutlet weak var usernameIdLabelOutlet: UILabel!
    
    @IBOutlet weak var usernameLabelOutlet: UILabel!
    
    @IBOutlet weak var townLabelOutlet: UILabel!
    
    @IBOutlet weak var targetLabelOutlet: UILabel!
    
    @IBOutlet weak var backgroundImageLoadView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCornerLayers()
        checkCurrentUser()
        reloadUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func setupCornerLayers(){
        
        self.settingsButtonOutlet.alpha = 0
        self.buttonSendMessageOutlet.alpha = 0
        
        self.mainProfileImageView.clipsToBounds = true
        self.buttonSendMessageOutlet.layer.cornerRadius = 22
        self.mainProfileImageView.layer.borderWidth = 3
        self.mainProfileImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewDidLayoutSubviews() {
        self.mainProfileImageView.layer.cornerRadius = self.mainProfileImageView.frame.height / 2
        self.backgroundImageLoadView.layer.cornerRadius = self.mainProfileImageView.frame.height / 2
    }
    

    
    
    func reloadUserInfo(){
        
        let userId = self.transferUid
        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            
            self.usernameLabelOutlet.text = value?["username"] as? String
            let usernameIdString = value?["usernameCode"] as? String
            if (usernameIdString != nil) {
                self.usernameIdLabelOutlet.text = "@" + usernameIdString!
            } else {
                self.usernameIdLabelOutlet.text = "@username"
            }
            if let userImageUrl = value?["profileImageUrl"] as? String {
                
                DispatchQueue.main.async {
                    self.mainProfileImageView.loadImageUsingCatchWithUrlString(urlString: userImageUrl)
                    self.backgroundProfileImageView.loadImageUsingCatchWithUrlString(urlString: userImageUrl)
                }
                
            } else {
                self.mainProfileImageView.image = UIImage(named: "DefaultProfileImage")
                self.backgroundProfileImageView.image = UIImage(named: "DefaultProfileImage")
            }
            self.targetLabelOutlet.text = value?["bio"] as? String
            //self.townProfileViewOut.text = value?["town"] as? String
        })
        
    }
    
    func checkCurrentUser(){
        print(transferUid)
        print(currentUid)
        if self.transferUid == currentUid {
            // show settings
            self.settingsButtonOutlet.alpha = 1
        }else{
            // show message button
            self.buttonSendMessageOutlet.alpha = 1
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonAction(_ sender: Any) {
    
        // show Edit Profile View Controller
        
    }
    
}
