//
//  EditProfileViewController.swift
//  YogaFit
//
//  Created by EUGENE on 11/30/18.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

struct Profile {
    var newUsernameCode: String
}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    var myProfile = [Profile]()
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var sexSegmented: UISegmentedControl!
    @IBOutlet weak var townField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    @IBOutlet weak var usernameCodeField: UITextField!
    
    @IBOutlet weak var logOutButtonOutlet: UIButton!
    
    @IBOutlet weak var buttonChangeProfilePhotoOutlet: UIButton!
    
    @IBOutlet weak var sportTextFieldOutlet: UITextField!
    
    @IBOutlet weak var levelTextFieldOutlet: UITextField!
    
    
    @IBOutlet weak var saveTabbarButtonOutlet: UIButton!
    
    //"username": username, "email": email, "profileImageUrl": profileImageUrl, "sex": "0", "town": "0", "bio": "0"
    var userName = ""
    var email = ""
    var profileImageUrl = ""
    var sex = ""
    var town = ""
    var bio = ""
    //var newImage = 0
    var usernameCode = ""
    var saveOldUserNameCodeForDelete = ""

   




    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        prepareCorners()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.saveTabbarButtonOutlet.isEnabled = false
        
        loadUserInFields()
        
        let tapTag: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showGooglePlacesView))
        self.townField.addGestureRecognizer(tapTag)
        
        let tapUsernameCode: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showChangeUsernamecodeVC))
        self.usernameCodeField.addGestureRecognizer(tapUsernameCode)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarView?.backgroundColor = .white
    
    }
    
    @objc func showChangeUsernamecodeVC(){
        
        
        guard let vc: ChangeUsernameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changeUsernameViewController") as? ChangeUsernameViewController else {
            
            print("View controller could not be instantiated")
            return
        }
        
        vc.delegate = self
        //vc.self.transferUid = Auth.auth().currentUser!.uid
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func showGooglePlacesView(){
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
//    @objc func showLogChatController() {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = mainStoryboard.instantiateViewController(withIdentifier: "NewMessageVCID") as! UITableViewController
//        //self.present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    func prepareCorners(){
        

        navigationController?.navigationBar.barTintColor = UIColor.white
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        
       // userNameTextField.layer.cornerRadius = 8
//        userNameTextField.layer.shadowColor = UIColor.black.cgColor
//        userNameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        userNameTextField.layer.shadowOpacity = 0.3
//        userNameTextField.layer.shadowRadius = 3.0
//        userNameTextField.layer.masksToBounds = false
        
        //townField.layer.cornerRadius = 8
//        townField.layer.shadowColor = UIColor.black.cgColor
//        townField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        townField.layer.shadowOpacity = 0.3
//        townField.layer.shadowRadius = 3.0
//        townField.layer.masksToBounds = false
        
       // bioField.layer.cornerRadius = 8
//        bioField.layer.shadowColor = UIColor.black.cgColor
//        bioField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        bioField.layer.shadowOpacity = 0.3
//        bioField.layer.shadowRadius = 3.0
//        bioField.layer.masksToBounds = false
        
            self.blackViewForLoadIcon.alpha = 0
            self.btnSaveOutlet.isEnabled = true
            self.btnCancelOutlet.isEnabled = true
        
        self.logOutButtonOutlet.layer.cornerRadius = 3
    }
    
    func loadUserInFields(){
        let ref = Database.database().reference()
        
        ref.child("users").child(self.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            self.userName = (value["username"] as? String)!
            
            
            if let checkUrl = (value["profileImageUrl"] as? String)
                {
                    self.profileImageUrl = checkUrl
                    self.profileImageView.loadImageUsingCatchWithUrlString(urlString: self.profileImageUrl)
            } else {
                self.profileImageView.image = UIImage(named: "DefaultProfileImage")
            }
            
            self.email = (value["email"] as? String)!
            self.sex = (value["sex"] as? String)!
            self.town = (value["town"] as? String)!
            self.bio = (value["bio"] as? String)!
            
            if let checkUsernameCode = value["usernameCode"] as? String {
                self.usernameCode = checkUsernameCode
                self.saveOldUserNameCodeForDelete = checkUsernameCode
            }
            
            DispatchQueue.main.async {
                
                self.saveTabbarButtonOutlet.isEnabled = true
                
                self.profileImageView.loadImageUsingCatchWithUrlString(urlString: self.profileImageUrl)
                self.townField.text = self.town
                self.bioField.text = self.bio
                self.userNameTextField.text = self.userName
                self.usernameCodeField.text = self.usernameCode
                
    
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
        self.usernameCode = self.usernameCodeField.text!
        
        let getIndex = sexSegmented.selectedSegmentIndex
        if getIndex == 0 {
            self.sex = "Male"
        }
        if getIndex == 1 {
            self.sex = "Female"
        }
  
        
        if self.saveOldUserNameCodeForDelete == self.usernameCode {
            
            Database.database().reference().child("users").child(self.uid!).updateChildValues(["username": self.userName, "email": self.email, "sex": self.sex, "town": self.town, "bio": self.bio, "usernameCode": self.saveOldUserNameCodeForDelete, "sport": self.sportTextFieldOutlet.text, "level":  self.levelTextFieldOutlet.text ])
            
            //just update
            
            
        }else{
            Database.database().reference().child("users").child(self.uid!).updateChildValues(["username": self.userName, "email": self.email, "sex": self.sex, "town": self.town, "bio": self.bio, "usernameCode": self.usernameCode.lowercased()])
            
            //just delete
            Database.database().reference().child("usernames").child(self.usernameCode.lowercased()).setValue(["user": self.uid!])
            Database.database().reference().child("usernames").child(self.saveOldUserNameCodeForDelete).removeValue()
            
        }
        
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
        
//        UIView.animate(withDuration: 0.4){
//            self.blackViewForLoadIcon.alpha = 1
//        }
        
//        UIView.animate(withDuration: 0.4){
//            self.btnSaveOutlet.isEnabled = false
//        }
//        UIView.animate(withDuration: 0.4){
//            self.btnCancelOutlet.isEnabled = false
//        }
        
        
//        self.userName = self.userNameTextField.text!
//        self.town = self.townField.text!
//        self.bio = self.bioField.text!
//        self.usernameCode = self.usernameCodeField.text!
        
//        let getIndex = sexSegmented.selectedSegmentIndex
//        if getIndex == 0 {
//            self.sex = "Male"
//        }
//        if getIndex == 1 {
//            self.sex = "Female"
//        }
        
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
                        Database.database().reference().child("users").child(self.uid!).updateChildValues(["profileImageUrl":  profileNewImageUrl.absoluteString])
                        
            
                        }

                    // show Change Image Photo name + enable
                    self.buttonChangeProfilePhotoOutlet.isEnabled = true
                    self.buttonChangeProfilePhotoOutlet.setTitle("Change Profile Photo", for: .normal)
                    
                    
//                    let alertController = UIAlertController(title: "Saved", message: "Sucsessful", preferredStyle: .alert)
//
//                    let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//                        print("You've pressed default");
//                    }
//                            alertController.addAction(action)
//                            self.present(alertController, animated: true, completion: nil)
//                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                            let loginController = mainStoryboard.instantiateViewController(withIdentifier: "dashboardControllerId")
//                            // self.present(loginController, animated: true, completion: nil)
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            //show window
//                            appDelegate.window?.rootViewController = loginController
                }
                

            })
        }
       
    }
    
        
    

    @IBAction func closeTabbarButtonAction(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func saveTabbarButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        updateUserData()
        
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
            //self.newImage = 1
        }
        
        
        dismiss(animated: true, completion: nil)
        
        self.buttonChangeProfilePhotoOutlet.isEnabled = false
        self.buttonChangeProfilePhotoOutlet.setTitle("Loading...", for: .normal)
        self.updateUserDataWithImage()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        //self.newImage = 0
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
    
    let changePrimarySportView = Bundle.main.loadNibNamed("ChooseTagView", owner: self, options: nil)?.first as? ChooseTagView
    
    @IBAction func buttonChangePrimarySportAction(_ sender: Any) {
        
//        if let changePrimarySportView = Bundle.main.loadNibNamed("ChooseTagView", owner: self, options: nil)?.first as? ChooseTagView {
        
        self.changePrimarySportView!.frame = self.view.bounds
            self.view.addSubview(self.changePrimarySportView! as ChooseTagView)
            //changePrimarySportView.frame = self.view.frame
            self.changePrimarySportView!.prepareView()
        //self.changePrimarySportView!.chooseTitleOutlet.text = "Title"
            self.changePrimarySportView!.doneButtonOutlet.addTarget(self, action: #selector(self.doneButtoonChooseTagViewAction), for: .touchUpInside)
        //}
        
    }
    
    @objc func doneButtoonChooseTagViewAction(){
        
        self.sportTextFieldOutlet.text = self.changePrimarySportView?.targetTagString
        print(self.changePrimarySportView?.targetTagString)
        
    }
    
    
    
    let changeExperienceLevelView = Bundle.main.loadNibNamed("ChooseExperienceLevel", owner: self, options: nil)?.first as? ChooseExperienceLevel
    
    @IBAction func chooseLevelButtonAction(_ sender: Any) {
        
        self.changeExperienceLevelView!.frame = self.view.bounds
        self.view.addSubview(self.changeExperienceLevelView! as ChooseExperienceLevel)
        //changePrimarySportView.frame = self.view.frame
        self.changeExperienceLevelView!.prepareView()
        self.changeExperienceLevelView!.doneButtonOutlet.addTarget(self, action: #selector(self.doneButtoonChooseLevelViewAction), for: .touchUpInside)
        
    }
    
    @objc func doneButtoonChooseLevelViewAction(){
        
        self.levelTextFieldOutlet.text = self.changeExperienceLevelView?.targetLevelString
        print(self.changeExperienceLevelView?.targetLevelString)
        
        
    }
    
    
    
    
    
    @IBAction func logOutButtonAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.logOutButtonOutlet.alpha = 0.4
        }) { (Bool) in
            self.logOutButtonOutlet.alpha = 1
        }
        
        let alertController = UIAlertController(title: "Sign out", message: "You sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "Log Out", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.handleLogout()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        //handleLogout()
        
    }
    
    func handleLogout(){
        print("HANDLE LOGOUT START")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = mainStoryboard.instantiateViewController(withIdentifier: "loginControllerId")
        // self.present(loginController, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = loginController
        print("HANDLE LOGOUT END")
    }
    
    
    
//END

}


extension EditProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
        self.townField.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension EditProfileViewController: ChangeUserNameDelegate {
    func chengedUsernamCodeDone(profile: Profile) {
        //
            print("EXTENSION WORK")
        self.myProfile.removeAll()
        self.myProfile.append(profile)
        // and put from myProfile to outlet .newUserNameCode
        // OR
        
        self.usernameCodeField.text = profile.newUsernameCode
//
//        self.dismiss(animated: true) {
//            self.myProfile.removeAll()
//            self.myProfile.append(profile)
//            // and put from myProfile to outlet .newUserNameCode
//            // OR
//
//            self.usernameCodeField.text = profile.newUsernameCode
//        }
        
    }
    
    
    
    
}
