//
//  RegisterController.swift
//  YogaFit
//
//  Created by EUGENE on 25.05.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase
class RegisterController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var registerBtnOut: UIButton!
    @IBOutlet weak var blackViewOut: UIView!
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pivatePolicyBlackView: UIView!
    @IBOutlet weak var privatePolicyWhiteView: UIView!
    @IBOutlet weak var privatePolicyButtonOutlet: UIButton!
    @IBOutlet weak var noInternetOutlet: UILabel!
    
    @IBOutlet weak var editImageBtnOutlet: UIButton!
    
    @IBAction func editImageBtn(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.editImageBtnOutlet.alpha = 0.4
        }) { (Bool) in
            self.editImageBtnOutlet.alpha = 1
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tapImageView(_ sender: Any) {
    
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
            imageView.image = selectedImage
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        setupCornerLayers()
        checkInternetConnection()
    }

    func setupCornerLayers(){
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        registerBtnOut.layer.cornerRadius = 20
        registerBtnOut.clipsToBounds = true
        blackViewOut.alpha = 0
        pivatePolicyBlackView.alpha = 0
        privatePolicyWhiteView.layer.cornerRadius = 8
        privatePolicyButtonOutlet.layer.cornerRadius = 4
        noInternetOutlet.alpha = 0
        noInternetOutlet.layer.shadowColor = UIColor.black.cgColor
        noInternetOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        noInternetOutlet.layer.shadowOpacity = 0.3
        noInternetOutlet.layer.shadowRadius = 3.0
    }
    
    func checkInternetConnection(){
        if CheckInternet.Connection(){
            if (self.noInternetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 0
                }
            }
            print("Connected")
        }
            
        else{
            if (self.noInternetOutlet.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
    }
    
    func setupGradient(){
        
            let layer = CAGradientLayer()
            layer.frame = registerBtnOut.bounds
            layer.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(167/255.0), green: CGFloat(71/255.0), blue: CGFloat(201/255.0), alpha: CGFloat(1.0) ).cgColor]
            layer.startPoint = CGPoint(x: 0.0,y: 1.0)
            layer.endPoint = CGPoint(x: 1.0,y: 0.0)
            registerBtnOut.layer.addSublayer(layer)
        
        
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    
    @IBAction func dissmisPrivatePolicyView(_ sender: Any) {
        checkInternetConnection()
        UIView.animate(withDuration: 0.4){
            self.pivatePolicyBlackView.alpha = 0
        }
    }
    
    
    @IBAction func acceptPrivatePolicyBtnAction(_ sender: Any) {
        if CheckInternet.Connection(){
            if (self.noInternetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 0
                }
            }
            print("Connected")
        
        UIView.animate(withDuration: 0.2, animations: {
            self.privatePolicyButtonOutlet.alpha = 0.4
        }) { (Bool) in
            self.privatePolicyButtonOutlet.alpha = 1
        }
        
        guard let username = usernameLabel.text, let email = emailLabel.text, let password = passwordLabel.text else{
            return
        }
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.pivatePolicyBlackView.alpha = 0
        }) { (Bool) in
            self.blackViewOut.alpha = 1
        }
        self.loadIndicator.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
                let alertController = UIAlertController(title: "Password or e-mail", message: "Error password or e-mail", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.blackViewOut.alpha = 0
                return
            }
            
            
            
            let uid = Auth.auth().currentUser!.uid 
            
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        guard let profileImageUrl = url?.absoluteString else {
                            // Uh-oh, an error occurred!
                            return
                        }
                    
                        
                        let values = ["username": username, "email": email, "profileImageUrl": profileImageUrl, "sex": "", "town": "", "bio": ""]
                        let ref = Database.database().reference()
                        ref.child("users").child(uid).setValue(values)
                        
                        //отправить первое сообщение для пользователя после регистрации
                        
                        let toId = uid
                        
                        let fromId = "ua28cUqmwnWto4gBLJL405tWIz92"
                        let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
                        let values1 = ["text": "Congratulations!", "toId": uid, "fromId": fromId, "timestamp": timestamp] as [String : Any]
                        let childRef = Database.database().reference().child("messages").childByAutoId()
                        childRef.updateChildValues(values1) { (error, ref) in
                            if error != nil {
                                print(error)
                                return
                            }
                            let userMessageRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                            let messageId = childRef.key
                            userMessageRef.updateChildValues([messageId: 1])
                            
                            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                            recipientUserMessagesRef.updateChildValues([messageId: 1])
                            
                            
                        }
                        
                        // конец отправки сообщения
                        // переключаем контроллер на основной
                        
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardControllerId")
                        // self.present(loginController, animated: true, completion: nil)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //show window
                        appDelegate.window?.rootViewController = loginController
                        
                        //заокнчили переключать контроллер на соновной
                        
                        
                    }
                })
            }
        }
        } else{
            if (self.noInternetOutlet.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
        
    }
    
   
    
    @IBAction func registerButton(_ sender: Any) {
        
        if CheckInternet.Connection(){
            if (self.noInternetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 0
                }
            }
            print("Connected")
        UIView.animate(withDuration: 0.2, animations: {
            self.registerBtnOut.alpha = 0.4
        }) { (Bool) in
            self.registerBtnOut.alpha = 1
        }

        if (self.passwordLabel.text != "" && self.emailLabel.text != "" && self.usernameLabel.text != "") {
            if self.passwordLabel.text == self.confirmPasswordLabel.text {
                if (passwordLabel.text!.count >= 6 && passwordLabel.text!.count <= 16) {
                    
                UIView.animate(withDuration: 0.4){
                    self.pivatePolicyBlackView.alpha = 1
                }
                dismissKeyboard()
                
            }
            else{
                let alertController = UIAlertController(title: "Password", message: "Create password 6-16 characters", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        
                
        } else {
            let alertController = UIAlertController(title: "Password", message: "Error password", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        } else {
            
            emailLabel.layer.borderColor = UIColor.red.cgColor
            emailLabel.layer.borderWidth = 1
            passwordLabel.layer.borderColor = UIColor.red.cgColor
            passwordLabel.layer.borderWidth = 1
            usernameLabel.layer.borderColor = UIColor.red.cgColor
            usernameLabel.layer.borderWidth = 1
            
        }
        }else {
            if (self.noInternetOutlet.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
        }

        
    
    

}
