//
//  UserClubInterfaceViewController.swift
//  YogaFit
//
//  Created by EUGENE on 8/8/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase


class UserClubInterfaceViewController: UIViewController {

    
    let uid = Auth.auth().currentUser?.uid
    var userTeamUid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadClubData()
        // Do any additional setup after loading the view.
    }
    
    func loadClubData(){
        
        
        
        Database.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            print(value)
            if let userClubUidFromFirebase = (value["clubUid"] as? String) {
                self.userTeamUid = userClubUidFromFirebase
                print(self.userTeamUid)
                if userClubUidFromFirebase == "new" {
                    print("User have New club - show create club button")
                    // show "Create Club" "Message View and show create club button
                    
                    
                } else {
                    print("User have Uid - show Manage club button")
                    // load club data from Firebase and show Menage button
                    
                }
            
            } else {
                
                
                print("user dont have club field")
            }
            
    
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func manageClubButtonAction(_ sender: Any) {
        
//        let manageClubViewController = ManageClubViewController()
//        //manageClubViewController = user
//        manageClubViewController.clubUidFromSegue = self.userTeamUid
//        present(manageClubViewController, animated: true, completion: nil)
        
        guard let vc: ManageClubViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "manageClubViewController") as? ManageClubViewController else {
            
            print("View controller could not be instantiated")
            return
        }
        
        vc.clubUidFromSegue = self.userTeamUid
        
        present(vc, animated: true, completion: nil)
        
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
