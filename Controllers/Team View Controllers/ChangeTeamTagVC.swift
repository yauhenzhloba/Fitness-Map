//
//  ChangeTeamTagVC.swift
//  YogaFit
//
//  Created by EUGENE on 8/4/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit

class ChangeTeamTagVC: UIViewController {

    
    @IBOutlet weak var runViewOutlet: UIView!
    
    @IBOutlet weak var bikeViewOutlet: UIView!
    
    @IBOutlet weak var yogaViewOutlet: UIView!
    
    @IBOutlet weak var workoutViewOutlet: UIView!
    
    @IBOutlet weak var tennisViewOutlet: UIView!
    
    var sendTeamTag = ""
    
//    let vc: SettingsTeamViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsTeamViewController") as? SettingsTeamViewController)!
    //vc.self.passwordFromFirstController = passwordLabel.text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cornerLayers()
    
        
        
        // Do any additional setup after loading the view.
    }
    

    
    func cornerLayers(){
        
        self.runViewOutlet.layer.cornerRadius = 11
        self.bikeViewOutlet.layer.cornerRadius = 11
        self.yogaViewOutlet.layer.cornerRadius = 11
        self.workoutViewOutlet.layer.cornerRadius = 11
        self.tennisViewOutlet.layer.cornerRadius = 11
        
        self.runViewOutlet.layer.borderWidth = 0
        self.runViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        self.bikeViewOutlet.layer.borderWidth = 0
        self.bikeViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        self.yogaViewOutlet.layer.borderWidth = 0
        self.yogaViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        self.tennisViewOutlet.layer.borderWidth = 0
        self.tennisViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        self.workoutViewOutlet.layer.borderWidth = 0
        self.workoutViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @IBAction func runButton(_ sender: Any) {
        
        self.sendTeamTag = "Run"
        self.cornerLayers()
        self.runViewOutlet.layer.borderWidth = 1
        self.runViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
    }
    
    
    @IBAction func bikeButton(_ sender: Any) {
        self.sendTeamTag = "Bike"
        self.cornerLayers()
        self.bikeViewOutlet.layer.borderWidth = 1
        self.bikeViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func yogaButton(_ sender: Any) {
        self.sendTeamTag = "Yoga"
        self.cornerLayers()
        self.yogaViewOutlet.layer.borderWidth = 1
        self.yogaViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func workoutButton(_ sender: Any) {
        self.sendTeamTag = "Run"
        self.cornerLayers()
        self.workoutViewOutlet.layer.borderWidth = 1
        self.workoutViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func tennisButton(_ sender: Any) {
        self.sendTeamTag = "Run"
        self.cornerLayers()
        self.tennisViewOutlet.layer.borderWidth = 1
        self.tennisViewOutlet.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
    
//        if segue.identifier == "settingsTeamViewController" {
//                        let vc = segue.destination as? SettingsTeamViewController
//                        vc?.takeTeamTag = self.sendTeamTag
//        }
//
////        if segue.destination is SettingsTeamViewController
////        {
////            let vc = segue.destination as? SettingsTeamViewController
////            vc?.takeTeamTag = self.sendTeamTag
////        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let settingsTeamViewController = segue.destination as? SettingsTeamViewController else {
//            return
//        }
//        settingsTeamViewController.takeTeamTag = self.sendTeamTag
//        //settingsTeamViewController.checkTeamTag()
        
        let vc = segue.destination as! SettingsTeamViewController
        vc.takeTeamTag = self.sendTeamTag
        //let receiverViewController =  SettingsTeamViewController
        
        //receiverViewController.takeTeamTag = sendTeamTag
    }
    
    @IBAction func saveTag(_ sender: Any) {
        
        guard let vc: SettingsTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsTeamViewController") as? SettingsTeamViewController else {
            
            print("View controller could not be instantiated")
            return
        }
        vc.takeTeamTag = self.sendTeamTag
        //self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        guard let vc: SettingsTeamViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsTeamViewController") as? SettingsTeamViewController else {
            
            print("View controller could not be instantiated")
            return
        }
        vc.takeTeamTag = self.sendTeamTag
        //self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true, completion: nil)
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
