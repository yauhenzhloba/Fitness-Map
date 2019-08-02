//
//  FirstRegisterController.swift
//  BoringSSL-GRPC
//
//  Created by EUGENE on 7/30/19.
//

import UIKit

class FirstRegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    @IBOutlet weak var noInternetOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.delegate = self
        self.setCornerLayers()
        
        // Do any additional setup after loading the view.
    }
    
    func setCornerLayers(){
        self.noInternetOutlet.alpha = 0
        self.noInternetOutlet.layer.shadowColor = UIColor.black.cgColor
        self.noInternetOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.noInternetOutlet.layer.shadowOpacity = 0.3
        self.noInternetOutlet.layer.shadowRadius = 3.0
        self.emailLabel.setGrayBottomBorder()
        self.passwordLabel.setGrayBottomBorder()
        self.confirmPasswordLabel.setGrayBottomBorder()
        self.nextButtonOutlet.layer.cornerRadius = 20
        self.nextButtonOutlet.clipsToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
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

    

    @IBAction func nextButton(_ sender: Any) {
        dismissKeyboard()
        if CheckInternet.Connection(){
            if (self.noInternetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.noInternetOutlet.alpha = 0
                }
            }
            print("Connected")
            UIView.animate(withDuration: 0.2, animations: {
                self.nextButtonOutlet.alpha = 0.4
            }) { (Bool) in
                self.nextButtonOutlet.alpha = 1
            }
            
            if (self.passwordLabel.text != "" && self.emailLabel.text != "") {
                if self.passwordLabel.text == self.confirmPasswordLabel.text {
                    if (passwordLabel.text!.count >= 6 && passwordLabel.text!.count <= 16) {
                        
                        //TRANSFER STRING TO NEXT VIEW
                        
                        guard let vc: RegisterController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerController") as? RegisterController else {
                            
                            print("View controller could not be instantiated")
                            return
                        }
                        
                        vc.self.passwordFromFirstController = passwordLabel.text
                        vc.self.emailFromFirstController = emailLabel.text
                        
                        
                        present(vc, animated: true, completion: nil)
                        
                        //END TRANSFER
                        
                    }
                    else{
                        let alertController = UIAlertController(title: "Password", message: "Create password 6-16 characters.", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Password", message: "Please confirm password.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                        print("You've pressed default");
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                
                emailLabel.setRedBottomBorder()
                passwordLabel.setRedBottomBorder()
                confirmPasswordLabel.setRedBottomBorder()
                
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
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //self.checkInternetConnection()
        
        if textField == self.emailLabel {  // OR with Tag like textfield.tag == 45
            let emailTextFieldString = emailLabel.text
            var result = self.isValidEmail(emailStr: emailTextFieldString!)
            if result == false {
                self.emailLabel.setRedBottomBorder()
            } else {
                self.emailLabel.setGrayBottomBorder()
            }
            
            //add check email in Firebase func
        } else {
            print("else")
        }
    }
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

}

extension UITextField {
    func setGrayBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setRedBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
