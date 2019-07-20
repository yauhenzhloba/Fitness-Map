//
//  EditProfileViewController.swift
//  YogaFit
//
//  Created by EUGENE on 11/30/18.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var scrollView: UIScrollView!
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var sexSegmented: UISegmentedControl!
    @IBOutlet weak var townField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    
    
    //"username": username, "email": email, "profileImageUrl": profileImageUrl, "sex": "0", "town": "0", "bio": "0"
    var userName = "empty"
    var email = "empty"
    var profileImageUrl = "empty"
    var sex = "empty"
    var town = "empty"
    var bio = "empty"
    var newImage = 0
    override func viewDidLoad() {

        super.viewDidLoad()
        prepareCorners()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        loadUserInFields()
        
        
    }
    
    
    
    @objc func showLogChatController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "NewMessageVCID") as! UITableViewController
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareCorners(){
        

        navigationController?.navigationBar.barTintColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) )
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.layer.shadowColor = UIColor.black.cgColor
        userNameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        userNameTextField.layer.shadowOpacity = 0.3
        userNameTextField.layer.shadowRadius = 3.0
        userNameTextField.layer.masksToBounds = false
        
        townField.layer.cornerRadius = 5
        townField.layer.shadowColor = UIColor.black.cgColor
        townField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        townField.layer.shadowOpacity = 0.3
        townField.layer.shadowRadius = 3.0
        townField.layer.masksToBounds = false
        
        bioField.layer.cornerRadius = 5
        bioField.layer.shadowColor = UIColor.black.cgColor
        bioField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bioField.layer.shadowOpacity = 0.3
        bioField.layer.shadowRadius = 3.0
        bioField.layer.masksToBounds = false
        
            self.blackViewForLoadIcon.alpha = 0
            self.btnSaveOutlet.isEnabled = true
            self.btnCancelOutlet.isEnabled = true
        
    }
    
    func loadUserInFields(){
        let ref = Database.database().reference()
        
        ref.child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.userName = (value?["username"] as? String)!
            if let checkUrl = (value?["profileImageUrl"] as? String)
                {
                    self.profileImageUrl = checkUrl
                    self.profileImageView.loadImageUsingCatchWithUrlString(urlString: self.profileImageUrl)
            } else {
                self.profileImageView.image = UIImage(named: "DefaultProfileImage")
            }
            
            self.email = (value?["email"] as? String)!
            self.sex = (value?["sex"] as? String)!
            self.town = (value?["town"] as? String)!
            self.bio = (value?["bio"] as? String)!
            
            DispatchQueue.main.async {
                self.profileImageView.loadImageUsingCatchWithUrlString(urlString: self.profileImageUrl)
                self.townField.text = self.town
                self.bioField.text = self.bio
                self.userNameTextField.text = self.userName
                
    
                if self.sex == "Male" {
                    self.sexSegmented.selectedSegmentIndex = 0
                }
                if self.sex == "Female" {
                    self.sexSegmented.selectedSegmentIndex = 1
                } else {
                    self.sexSegmented.selectedSegmentIndex = 0
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateUserData()
    {
        self.userName = self.userNameTextField.text!
        self.town = self.townField.text!
        self.bio = self.bioField.text!
        
        let getIndex = sexSegmented.selectedSegmentIndex
        if getIndex == 0 {
            self.sex = "Male"
        }
        if getIndex == 1 {
            self.sex = "Female"
        }
  
        
        Database.database().reference().child("users").child(self.uid!).setValue(["username": self.userName, "email": self.email, "profileImageUrl":  self.profileImageUrl, "sex": self.sex, "town": self.town, "bio": self.bio])
        
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
    
    
    @IBOutlet weak var blackViewForLoadIcon: UIView!
    @IBOutlet weak var btnSaveOutlet: UIBarButtonItem!
    
    @IBOutlet weak var btnCancelOutlet: UIBarButtonItem!
    
    
    
    func updateUserDataWithImage(){
        
        UIView.animate(withDuration: 0.4){
            self.blackViewForLoadIcon.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4){
            self.btnSaveOutlet.isEnabled = false
        }
        UIView.animate(withDuration: 0.4){
            self.btnCancelOutlet.isEnabled = false
        }
        
        
        self.userName = self.userNameTextField.text!
        self.town = self.townField.text!
        self.bio = self.bioField.text!
        
        let getIndex = sexSegmented.selectedSegmentIndex
        if getIndex == 0 {
            self.sex = "Male"
        }
        if getIndex == 1 {
            self.sex = "Female"
        }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
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
                            Database.database().reference().child("users").child(self.uid!).setValue(["username": self.userName, "email": self.email, "profileImageUrl":  profileNewImageUrl, "sex": self.sex, "town": self.town, "bio": self.bio])
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
    
        
    
    @IBAction func save(_ sender: Any) {
        self.view.endEditing(true)
        if newImage == 0 {
            updateUserData()
        }
        if newImage == 1 {
            updateUserDataWithImage()
        }
    }
    
    
    @IBAction func updateUserImage(_ sender: Any) {
        
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
            self.profileImageView.image = selectedImage
            self.newImage = 1
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        self.newImage = 0
        dismiss(animated: true, completion: nil)
    }
    

    
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
//END

}
