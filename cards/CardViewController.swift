//
//  CardViewController.swift
//  YogaFit
//
//  Created by EUGENE on 1/14/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {


    @IBOutlet weak var handleArea: UIView!
    
    @IBOutlet weak var slideView: UIView!
    
    var dashBoardViewController:DashboardController!
    
    override func viewDidLoad() {
        slideView.layer.cornerRadius = 3
        slideView.clipsToBounds = true
    }
    
    
    @IBAction func btnCloseCardView(_ sender: Any) {
    
        dashBoardViewController.hideCardView()
    
    }
    
}
