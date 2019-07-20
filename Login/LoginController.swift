//
//  LoginController.swift
//  YogaFit
//
//  Created by EUGENE on 25.05.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase




class LoginController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var LoginBtnPutlet: UIButton!
    
    @IBOutlet weak var internetOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setGradient()
        
        LoginBtnPutlet.layer.cornerRadius = 20
        LoginBtnPutlet.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        self.view.addGestureRecognizer(tap)
        internetOutlet.layer.shadowColor = UIColor.black.cgColor
        internetOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        internetOutlet.layer.shadowOpacity = 0.3
        internetOutlet.layer.shadowRadius = 3.0
        checkInternetConnection()

        //self.view.addGestureRecognizer(tap)
    }
    
    func checkInternetConnection(){
        if CheckInternet.Connection(){
            if (self.internetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.internetOutlet.alpha = 0
                }
            }
            print("Connected")
        }
            
        else{
            if (self.internetOutlet.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                    self.internetOutlet.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }

    
    func setGradient(){
        let layer = CAGradientLayer()
        layer.frame = LoginBtnPutlet.bounds
        layer.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(167/255.0), green: CGFloat(71/255.0), blue: CGFloat(201/255.0), alpha: CGFloat(1.0) ).cgColor]
        layer.startPoint = CGPoint(x: 0.0,y: 1.0)
        layer.endPoint = CGPoint(x: 1.0,y: 0.0)
        LoginBtnPutlet.layer.addSublayer(layer)
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if CheckInternet.Connection(){
            if (self.internetOutlet.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.internetOutlet.alpha = 0
                }
            }
            print("Connected")
        UIView.animate(withDuration: 0.2, animations: {
            self.LoginBtnPutlet.alpha = 0.4
        }) { (Bool) in
            self.LoginBtnPutlet.alpha = 1
        }
        
        guard let email = emailLabel.text, let password = passwordLabel.text else {
            print("Form Is Not Valid")
            return
        }
            
        Auth.auth().signIn(withEmail: email, password: password){ (user, err) in
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardControllerId")
            // self.present(loginController, animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //show window
            appDelegate.window?.rootViewController = loginController
            
            if err != nil {
                print(err!)
                print("ERROR SING IN")
                return
            }
        }
        }else{
            if (self.internetOutlet.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                    self.internetOutlet.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
    }
    

}


