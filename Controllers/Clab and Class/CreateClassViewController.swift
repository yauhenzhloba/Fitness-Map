//
//  CreateClassViewController.swift
//  YogaFit
//
//  Created by EUGENE on 8/8/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit

class CreateClassViewController: UIViewController {

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseTagButtonAction(_ sender: Any) {
        
        if let chooseTagView = Bundle.main.loadNibNamed("ChooseTagView", owner: self, options: nil)?.first as? ChooseTagView {
            
            self.view.addSubview(chooseTagView)
            chooseTagView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }
        
    }
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
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
