//
//  ChooseExperienceLevel.swift
//  YogaFit
//
//  Created by EUGENE on 8/14/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit

class ChooseExperienceLevel: UIView {

    @IBOutlet weak var beginnerButtonOutlet: UIButton!
    
    @IBOutlet weak var interButtonOutlet: UIButton!
    
    @IBOutlet weak var advancedButtonOutlet: UIButton!
    
    @IBOutlet weak var expertButtonOutlet: UIButton!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    var targetLevelString = ""
    
    func prepareView(){
        self.setCornerLayers()
        self.doneButtonOutlet.isEnabled = false
        
        
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
    
    
    func setCornerLayers(){
        
        self.doneButtonOutlet.layer.cornerRadius = 22
        //self.errorMessageOutlet.alpha = 0
        
        self.beginnerButtonOutlet.layer.cornerRadius = 16
        self.beginnerButtonOutlet.layer.borderWidth = 1
        self.beginnerButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.beginnerButtonOutlet.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.interButtonOutlet.layer.cornerRadius = 16
        self.interButtonOutlet.layer.borderWidth = 1
        self.interButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.interButtonOutlet.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.advancedButtonOutlet.layer.cornerRadius = 16
        self.advancedButtonOutlet.layer.borderWidth = 1
        self.advancedButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.advancedButtonOutlet.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.expertButtonOutlet.layer.cornerRadius = 16
        self.expertButtonOutlet.layer.borderWidth = 1
        self.expertButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        self.expertButtonOutlet.setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    
    @IBAction func beginnerButtonAction(_ sender: Any) {
        
        self.doneButtonOutlet.isEnabled = true
        self.setCornerLayers()
        self.beginnerButtonOutlet.layer.cornerRadius = 16
        self.beginnerButtonOutlet.layer.borderWidth = 1
        self.beginnerButtonOutlet.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        self.beginnerButtonOutlet.setTitleColor(UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ), for: .normal)
        self.targetLevelString = "Beginner"
        
    }
    
    
    @IBAction func interButtonAction(_ sender: Any) {
        
        self.doneButtonOutlet.isEnabled = true
        self.setCornerLayers()
        self.interButtonOutlet.layer.cornerRadius = 16
        self.interButtonOutlet.layer.borderWidth = 1
        self.interButtonOutlet.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        self.interButtonOutlet.setTitleColor(UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ), for: .normal)
        self.targetLevelString = "Intermediate"
        
    }
    
    @IBAction func advancedButtonAction(_ sender: Any) {
        
        self.doneButtonOutlet.isEnabled = true
        self.setCornerLayers()
        self.advancedButtonOutlet.layer.cornerRadius = 16
        self.advancedButtonOutlet.layer.borderWidth = 1
        self.advancedButtonOutlet.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        self.advancedButtonOutlet.setTitleColor(UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ), for: .normal)
        self.targetLevelString = "Advanced"
        
    }
    
    
    @IBAction func expertButtonAction(_ sender: Any) {
        
        self.doneButtonOutlet.isEnabled = true
        self.setCornerLayers()
        self.expertButtonOutlet.layer.cornerRadius = 16
        self.expertButtonOutlet.layer.borderWidth = 1
        self.expertButtonOutlet.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        self.expertButtonOutlet.setTitleColor(UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ), for: .normal)
        self.targetLevelString = "Expert"
        
    }
    
    
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        removeFromSuperview()
        
    }
    
    
 // END
}
