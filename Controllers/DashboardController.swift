//
//  DashboardController.swift
//  YogaFit
//
//  Created by EUGENE on 25.05.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import FirebaseMessaging

class DashboardController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var messageImageViewOutlet: UIImageView!
    @IBOutlet weak var viewImagePin: UIImageView!
    @IBOutlet weak var cancelBtnAddPointViewOutlet: UIButton!
    
    
    @IBOutlet weak var mappin4: UIImageView!
    
    
    var setCircleAndView = 0
     let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D!
    var pinCoordinate: CLLocationCoordinate2D!

    var pin: AnnotationPin!
    var pins = [AnnotationPin]()
    var points: [Point] = []
    
    // properties for cardView
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    
    @IBOutlet weak var cardViewController: UIView!
    
    @IBOutlet weak var handleArea: UIView!
    
    
  //  var cardViewController:CardViewController!
  //  var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = 250
    let cardHandleAreaHeight:CGFloat = 90
    
    var cardVisible = false
    var nextState:CardState{
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    @IBOutlet weak var viewForInternetConnection: UIView!
    
    
    func checkInternetConnectionInVC(){
        if CheckInternet.Connection(){
            if (self.viewForInternetConnection.alpha == 1) {
                UIView.animate(withDuration: 0.4){
                    self.viewForInternetConnection.alpha = 0
                }
            }
            print("Connected")
        }
            
        else{
            if (self.viewForInternetConnection.alpha == 0) {
                UIView.animate(withDuration: 0.4){
                self.viewForInternetConnection.alpha = 1
                }
            }
            print("Your Device is not connected with internet")
        }
    }
    
    func hideCardView() {
        //cardViewController.view.removeFromSuperview()
    }
    
    
    
    func setupCard(){

        
        
        self.cardViewController.layer.cornerRadius = 14
        self.cardViewController.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DashboardController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DashboardController.handleCardPan(recognizer:)))
        
        self.handleArea.addGestureRecognizer(tapGestureRecognizer)
        self.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
//            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
//                switch state {
//                case .expanded:
//                    self.cardViewController.layer.cornerRadius = 12
//                case .collapsed:
//                    self.cardViewController.layer.cornerRadius = 0
//                }
//            }
//
//            cornerRadiusAnimator.startAnimation()
//            runningAnimations.append(cornerRadiusAnimator)
            
//            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
//                switch state {
//                case .expanded:
//                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
//                case .collapsed:
//                    self.visualEffectView.effect = nil
//                }
//            }
//            
//            blurAnimator.startAnimation()
//            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // NEW CARD VIEW CONTROLLER
    

    
    
    enum CardState2 {
        case expanded
        case collapsed
    }
    
    
    @IBOutlet weak var cardViewController2: UIView!
    
    @IBOutlet weak var handleArea2: UIView!
    
    //  var cardViewController:CardViewController!
    //  var visualEffectView:UIVisualEffectView!
    
    let cardHeight2:CGFloat = 415
    let cardHandleAreaHeight2:CGFloat = 155
    
    var cardVisible2 = false
    var nextState2:CardState2{
        return cardVisible2 ? .expanded : .collapsed
    }
    
    var runningAnimations2 = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted2:CGFloat = 0
    

    
    
    func setupCard2(){
      
        
        self.cardViewController2.layer.cornerRadius = 14
        self.cardViewController2.clipsToBounds = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(DashboardController.handleCardTap2(recognzier:)))
        //let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(DashboardController.handleCardPan2(recognizer:)))
        self.outletPickerVisualEffectView.alpha = 0
        self.handleArea2.addGestureRecognizer(tapGestureRecognizer2)
        //self.handleArea2.addGestureRecognizer(panGestureRecognizer2)
        
        self.outletBtnTime.layer.cornerRadius = 22
       // self.outletBtnTime.layer.borderWidth = 1
        //self.outletBtnTime.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.outletBtnInterval.layer.cornerRadius = 22
       // self.outletBtnInterval.layer.borderWidth = 1
       // self.outletBtnInterval.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.outletBtnType.layer.cornerRadius = 22
       // self.outletBtnType.layer.borderWidth = 1
       // self.outletBtnType.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.outletBtnLevel.layer.cornerRadius = 22
        //self.outletBtnLevel.layer.borderWidth = 1
        //self.outletBtnLevel.layer.borderColor = UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor
        
        
    }
    
    @objc
    func handleCardTap2(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded2(state: nextState2, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan2 (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition2(state: nextState2, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.handleArea2)
            var fractionComplete = translation.y / cardHeight2
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition2(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition2()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded2 (state:CardState2, duration:TimeInterval) {
        if runningAnimations2.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController2.frame.origin.y = self.view.frame.height - self.cardHeight2
                case .collapsed:
                    self.cardViewController2.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight2
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible2 = !self.cardVisible2
                self.runningAnimations2.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations2.append(frameAnimator)
            
        }
    }
    
    func startInteractiveTransition2(state: CardState2, duration:TimeInterval) {
        if runningAnimations2.isEmpty {
            animateTransitionIfNeeded2(state: state, duration: duration)
        }
        for animator in runningAnimations2 {
            animator.pauseAnimation()
            animationProgressWhenInterrupted2 = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition2(fractionCompleted:CGFloat) {
        for animator in runningAnimations2 {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted2
        }
    }
    
    func continueInteractiveTransition2 (){
        for animator in runningAnimations2 {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    // END NEW CARD VIEW CONTROLLER
    
    override func viewDidLoad() {
       super.viewDidLoad()
        self.checkIfUserIsLoggedIn()
        
        
        
        
        viewMenuBar.alpha = 1
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        mappin4.layer.shadowColor = UIColor.black.cgColor
        mappin4.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        mappin4.layer.shadowOpacity = 0.6
        mappin4.layer.shadowRadius = 5.0
        mappin4.layer.masksToBounds = false
        setupCard2()
        setupCard()
        //self.setGradientForViews()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
   
    
    
    @IBOutlet weak var squareUiView1: UIView!
    
    @IBOutlet weak var squareUiView2: UIView!
    
    @IBOutlet weak var squareUiView3: UIView!
    
    @IBOutlet weak var squareUiView4: UIView!
    
    @IBOutlet weak var squareUiView5: UIView!
    
    @IBOutlet weak var sliderUiView: UIView!
    
    @IBOutlet weak var view1pxForShadow: UIView!
    
    @IBOutlet weak var viewCardVC2: UIView!
    
    @IBOutlet weak var viewCardVC3: UIView!
    
    @IBOutlet weak var viewCardVC1: UIView!
    
    @IBOutlet weak var viewCardVC4: UIView!
    
    @IBOutlet weak var view1pxForShadow2: UIView!
    
    @IBOutlet weak var sliderUiView2: UIView!
    
    @IBOutlet weak var doneBtnForPickerViewOut: UIButton!

    @IBOutlet weak var viewMenuBar: UIView!
    
    @IBOutlet weak var btnMyPointOut: UIView!
    
    @IBOutlet weak var btnNewPointOut: UIView!
    
    
    func setCornerLayers() {
        
        self.viewMenuBar.layer.shadowColor = UIColor.black.cgColor
        self.viewMenuBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.viewMenuBar.layer.shadowOpacity = 0.3
        self.viewMenuBar.layer.shadowRadius = 4.0
        self.viewMenuBar.layer.cornerRadius = 32
        
        self.viewForInternetConnection.layer.cornerRadius = 8

        
        view1pxForShadow2.layer.shadowColor = UIColor.black.cgColor
        view1pxForShadow2.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view1pxForShadow2.layer.shadowOpacity = 0.4
        view1pxForShadow2.layer.shadowRadius = 4.0
        
        view1pxForShadow.layer.shadowColor = UIColor.black.cgColor
        view1pxForShadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view1pxForShadow.layer.shadowOpacity = 0.4
        view1pxForShadow.layer.shadowRadius = 4.0
        
        self.sliderUiView.layer.cornerRadius = 3
                self.sliderUiView2.layer.cornerRadius = 3
        
          self.doneBtnForPickerViewOut.layer.cornerRadius = 22
        
        self.squareUiView1.layer.shadowColor = UIColor.black.cgColor
        self.squareUiView1.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.squareUiView1.layer.shadowOpacity = 0.3
        self.squareUiView1.layer.shadowRadius = 5.0
        self.squareUiView1.layer.cornerRadius = 5
        self.squareUiView1.layer.borderWidth = 1
        self.squareUiView1.layer.borderColor = UIColor( red: CGFloat(214/255.0), green: CGFloat(214/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) ).cgColor
        
        
        self.squareUiView2.layer.shadowColor = UIColor.black.cgColor
        self.squareUiView2.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.squareUiView2.layer.shadowOpacity = 0.3
        self.squareUiView2.layer.shadowRadius = 5.0
        self.squareUiView2.layer.cornerRadius = 5
        self.squareUiView2.layer.borderWidth = 1
        self.squareUiView2.layer.borderColor = UIColor( red: CGFloat(214/255.0), green: CGFloat(214/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.squareUiView3.layer.shadowColor = UIColor.black.cgColor
        self.squareUiView3.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.squareUiView3.layer.shadowOpacity = 0.3
        self.squareUiView3.layer.shadowRadius = 5.0
        self.squareUiView3.layer.cornerRadius = 5
        self.squareUiView3.layer.borderWidth = 1
        self.squareUiView3.layer.borderColor = UIColor( red: CGFloat(214/255.0), green: CGFloat(214/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.squareUiView4.layer.shadowColor = UIColor.black.cgColor
        self.squareUiView4.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.squareUiView4.layer.shadowOpacity = 0.3
        self.squareUiView4.layer.shadowRadius = 5.0
        self.squareUiView4.layer.cornerRadius = 5
        self.squareUiView4.layer.borderWidth = 1
        self.squareUiView4.layer.borderColor = UIColor( red: CGFloat(214/255.0), green: CGFloat(214/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.squareUiView5.layer.shadowColor = UIColor.black.cgColor
        self.squareUiView5.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.squareUiView5.layer.shadowOpacity = 0.3
        self.squareUiView5.layer.shadowRadius = 5.0
        self.squareUiView5.layer.cornerRadius = 5
        self.squareUiView5.layer.borderWidth = 1
        self.squareUiView5.layer.borderColor = UIColor( red: CGFloat(214/255.0), green: CGFloat(214/255.0), blue: CGFloat(214/255.0), alpha: CGFloat(1.0) ).cgColor
        
        self.viewCardVC1.layer.shadowColor = UIColor.black.cgColor
        self.viewCardVC1.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewCardVC1.layer.shadowOpacity = 0.3
        self.viewCardVC1.layer.shadowRadius = 3.0
        
        self.viewCardVC2.layer.shadowColor = UIColor.black.cgColor
        self.viewCardVC2.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewCardVC2.layer.shadowOpacity = 0.3
        self.viewCardVC2.layer.shadowRadius = 3.0
        
        self.viewCardVC3.layer.shadowColor = UIColor.black.cgColor
        self.viewCardVC3.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewCardVC3.layer.shadowOpacity = 0.3
        self.viewCardVC3.layer.shadowRadius = 3.0
        
        self.viewCardVC4.layer.shadowColor = UIColor.black.cgColor
        self.viewCardVC4.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewCardVC4.layer.shadowOpacity = 0.3
        self.viewCardVC4.layer.shadowRadius = 3.0
        
        self.goBtnOutl.layer.shadowColor = UIColor.black.cgColor
        self.goBtnOutl.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.goBtnOutl.layer.shadowOpacity = 0.5
        self.goBtnOutl.layer.shadowRadius = 5.0
        self.goBtnOutl.layer.cornerRadius = 5
        
        
        
        deletePointBtnOut.alpha = 0
        viewImagePin.alpha = 0
        self.cardViewController.alpha = 0
         self.cardViewController2.alpha = 0
        mainViewProfileViewOut.alpha = 0
        self.viewForInternetConnection.alpha = 0
        self.cardViewController.clipsToBounds = true
        


        
        
        
        statusBarView.layer.shadowColor = UIColor.black.cgColor
        statusBarView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        statusBarView.layer.shadowOpacity = 0.2
        statusBarView.layer.shadowRadius = 5.0
        statusBarView.layer.masksToBounds = false
        

        messageImageViewOutlet.layer.cornerRadius = 30
        messageImageViewOutlet.clipsToBounds = true
        
//        self.messageCalloutBtn.layer.shadowColor = UIColor.black.cgColor
//        self.messageCalloutBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        self.messageCalloutBtn.layer.shadowOpacity = 0.3
//        self.messageCalloutBtn.layer.shadowRadius = 6.0
        self.messageCalloutBtn.layer.cornerRadius = 6

        
//        self.deletePointBtnOut.layer.shadowColor = UIColor.black.cgColor
//        self.deletePointBtnOut.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        self.deletePointBtnOut.layer.shadowOpacity = 0.3
//        self.deletePointBtnOut.layer.shadowRadius = 6.0
        self.deletePointBtnOut.layer.cornerRadius = 6
        
        
        //addPointFirebase

        
        cancelBtnAddPointViewOutlet.layer.cornerRadius = 11
        cancelBtnAddPointViewOutlet.clipsToBounds = true

        
    }
    
    var pointCount: UInt = 0
    
    @IBAction func setPointInFirebase(_ sender: Any) {
        
        //check if user have more than 5 points
        
        let userID = Auth.auth().currentUser?.uid
        var pointCount: Int
        Database.database().reference().child("user-points").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in

        
               print(userID)
                self.pointCount = snapshot.childrenCount
                print(snapshot.childrenCount)

            if self.pointCount == 0 {
        
                self.pinCoordinate = self.mapKitView.centerCoordinate
                if let llCoordinates = self.pinCoordinate {
                    let lLat: NSNumber
                    lLat = llCoordinates.latitude as NSNumber
                    print(lLat)
                    let lLong: NSNumber
                    lLong = llCoordinates.longitude as NSNumber
                    print(lLong)
                    
                    let btnInterval = self.outletBtnInterval.currentTitle
                    let btnType = self.outletBtnType.currentTitle
                    let btnLevel = self.outletBtnLevel.currentTitle
                    let btnTime = self.outletBtnTime.currentTitle
                    let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
                    let userID = Auth.auth().currentUser?.uid
                    let views = 0
                    let values = ["idOwner": userID,"time": btnTime, "type": btnType, "level": btnLevel,"interval": btnInterval, "lLat": lLat, "lLong": lLong, "timestamp": timestamp, "views": views] as [String : Any]
                    let ref = Database.database().reference().child("points").childByAutoId()
                    ref.updateChildValues(values) { (error, ref) in
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        
                        let userRef = Database.database().reference().child("user-points").child(userID!)
                        let messageId = ref.key
                        userRef.updateChildValues(["pinid": messageId])
                        
                    }
                    
                    let alertController = UIAlertController(title: "Thank you!", message: "New point was added", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                        print("You've pressed default");
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.mainSettingsWithoutLocation()
                }
                
            } else {

                let alertController = UIAlertController(title: "Sorry!", message: "You already have point", preferredStyle: .alert)

                let action = UIAlertAction(title: "Try again", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)

            }
        
  
        }, withCancel: nil)
        
      //   print(pointCount)
        
        
        

    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        
        
//        if let title = annotation.title, title == "Run" {
//            annotationView.image = UIImage(named: "mappin")
//            annotationView.alpha = 0.5
//        } else{
//        annotationView.image = UIImage(named: "local")
//        }
        if let title = annotation.title{
        var pinImage = UIImage(named: "local")
        
        switch title {
        case "Run":
            pinImage = UIImage(named: "runicon10")
            
        case "Yoga":
           pinImage = UIImage(named: "yogaicon10")
        case "Workout":
            pinImage = UIImage(named: "workouticon10")
        case "Bike":
            pinImage = UIImage(named: "bikeicon10")
        case "Tennis":
            pinImage = UIImage(named: "tennisicon10")
        default:
            pinImage = UIImage(named: "local")
            }
            
        
        
        //let pinImage = UIImage(named: "pin maps.png")
        let size = CGSize(width: 36, height: 36)
        UIGraphicsBeginImageContext(size)
        //pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView.image = pinImage
         annotationView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
           // annotationView
            annotationView.layer.shadowColor = UIColor.black.cgColor
            annotationView.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
            annotationView.layer.shadowOpacity = 0.6
            annotationView.layer.shadowRadius = 5.0
            annotationView.layer.masksToBounds = false
            
        }
        annotationView.canShowCallout = false
        return annotationView
        
        
    }

    
    
    var myPoinLlat: Double? = 0.0
    var myPointLlong: Double? = 0.0
    
    private func timerCheckIfUserHasPoin(){
        UIView.animate(withDuration: 0.4){
            self.viewMenuBar.alpha = 0
        }
        UIView.animate(withDuration: 0.4){
            self.btnMyPointOut.alpha = 0
        }
        UIView.animate(withDuration: 0.4){
            self.btnNewPointOut.alpha = 0
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkIfUserHasPoin), userInfo: nil, repeats: false)
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
    }
    
    
    var timer: Timer?
    
    
    
    @objc func checkIfUserHasPoin(){

//        let ref = Database.database().reference().child("points")
//        ref.observe(.childAdded, with: { (snapshot) in
//            let value = snapshot.value as? [String : AnyObject]
//            if let ownerId = value?["idOwner"] as? String {
//                if (ownerId == Auth.auth().currentUser?.uid)
        
        
        let userID = Auth.auth().currentUser?.uid
        var pointCount: Int
        Database.database().reference().child("user-points").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? [String : AnyObject]
            if (value != nil){
            let pinId = value?["pinid"] as? String
            self.pointCount = snapshot.childrenCount
            print(snapshot.childrenCount)
            print(pinId!, "PinId")
            
            if self.pointCount >= 1
        {
            UIView.animate(withDuration: 0.4){
                self.viewMenuBar.alpha = 1
            }
                self.btnMyPointOut.alpha = 1
                self.btnNewPointOut.alpha = 0

                    let ref = Database.database().reference().child("points").child(pinId!)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? [String : AnyObject]
                    self.myPoinLlat = value?["lLat"] as? Double
                    self.myPointLlong = value?["lLong"] as? Double

            }, withCancel: nil)
            }
            else{
                self.btnMyPointOut.alpha = 0
                self.btnNewPointOut.alpha = 1
                UIView.animate(withDuration: 0.4){
                    self.viewMenuBar.alpha = 1
                }
            }
            } else {
                //addnew spot show
                //mypoint close
                self.btnMyPointOut.alpha = 0
                self.btnNewPointOut.alpha = 1
                UIView.animate(withDuration: 0.4){
                    self.viewMenuBar.alpha = 1
                }
            }
        }, withCancel: nil)
    }
    
    @IBOutlet weak var myPointImageOutlet: UIImageView!
    
    @IBAction func showMyPointCoordinate(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.myPointImageOutlet.alpha = 0.4
        }) { (Bool) in
            self.myPointImageOutlet.alpha = 1
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: self.myPoinLlat!, longitude: self.myPointLlong!)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapKitView.setRegion(region, animated: true)
    }
    
    
    func loadPoints(){
        self.viewMenuBar.alpha = 0
        self.checkInternetConnectionInVC()
        self.checkIfUserHasPoin()
        self.pins.removeAll()
        self.points.removeAll()
        let allAnnotations = self.mapKitView.annotations
        self.mapKitView.removeAnnotations(allAnnotations)
        
            let ref = Database.database().reference().child("points")
            ref.observe(.childAdded, with: { (snapshot) in
                
                //print(snapshot.key)
                let value = snapshot.value as? [String : AnyObject]
                let ownerIdForDelete = value?["idOwner"] as? String
                let pointtimeStamp = value?["timestamp"] as? NSNumber
                let pointIdForDelete = snapshot.key
                var pointTimeStampPlus24Hours = pointtimeStamp!.intValue + 86400
                var currentTimeStampDouble = (Date().timeIntervalSince1970) as Double
                
                let currentTimeStampInt:Int = Int(currentTimeStampDouble)
                if (currentTimeStampInt < pointTimeStampPlus24Hours) {
                    //add point on map
                    let point = Point()
                    point.idOwner = value?["idOwner"] as? String
                    
                    //point.time = value?["time"] as? String
                    //point.type = value?["type"] as? String
                    // let lLat = value?["lLat"] as? Double
                    //  let lLong = value?["lLong"] as? Double
                    // let key = snapshot.key
                    let coordinate = CLLocationCoordinate2D(latitude: value?["lLat"] as! Double, longitude: value?["lLong"] as! Double)
                    //self.pin = AnnotationPin(title: value?["idOwner"] as! String, subtitle: snapshot.key, coordinate: coordinate)
                    self.pin = AnnotationPin(title: value?["type"] as! String, subtitle: snapshot.key, coordinate: coordinate)
                    self.pins.append(self.pin)
                    self.points.append(point)
                    DispatchQueue.main.async {
                        self.mapKitView.addAnnotations(self.pins)
                    }
                    print("add on map")
                    
                } else {
       
                    Database.database().reference().child("points").child(pointIdForDelete).removeValue()
                    Database.database().reference().child("user-points").child(ownerIdForDelete!).removeValue()
                    // delete from user-points
                    print("delete from map")
                    
                }
               
                
             
                
            }, withCancel: nil)
        
    }
    
    
    @IBAction func addNewPointAction(_ sender: Any) {
            pinCoordinate = mapKitView.centerCoordinate
            let coordinateLat = pinCoordinate.latitude as CLLocationDegrees
            let coordinateLong = pinCoordinate.longitude as CLLocationDegrees
            // self.coordinatelabel.text = String(describing: coordinateLat as NSNumber)
            
            mapKitView.removeOverlays(mapKitView.overlays)
            //let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geofence")
            let circle = MKCircle(center: self.pinCoordinate, radius: 75)
            
            //mapKitView.add(circle as MKOverlay)
            
            showPointView()
        
        UIView.animate(withDuration: 0.4){
            self.viewMenuBar.alpha = 0
        }
        
            let region = MKCoordinateRegion(center: pinCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
            self.mapKitView.setRegion(region, animated: true)
            

    }
    
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {return MKOverlayRenderer()}
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        //circleRenderer.strokeColor = .red
        circleRenderer.fillColor = UIColor.black
        circleRenderer.alpha = 0.3
        return circleRenderer
    }
    
    
    func showMyLocation(){
        self.checkInternetConnectionInVC()
        mapKitView.delegate = self
//        mapKitView.showsScale = false
//        mapKitView.showsPointsOfInterest = false
//        mapKitView.showsUserLocation = true
//        mapKitView.showsBuildings = false
//        mapKitView.showsCompass = false
//        mapKitView.mapType = .mutedStandard
        mapKitView.tintColor = UIColor(red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
        //locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            //locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            print("locationServicesEnabled = if ...")
        }else{
            print("locationServicesEnabled = else...")
        }
        
        //let sourceCoordinates = locationManager.location?.coordinate
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        mapKitView.userTrackingMode = .follow
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    @IBOutlet weak var viewStatusBarShadow: UIView!
    
    @IBOutlet weak var viewStatusBarGradient: UIView!
    
    @IBOutlet weak var gradientViewForProfileView: UIView!
    
    func setGradientForViews(){
        
        self.viewStatusBarShadow.layer.shadowColor = UIColor.black.cgColor
        self.viewStatusBarShadow.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.viewStatusBarShadow.layer.shadowOpacity = 0.5
        self.viewStatusBarShadow.layer.shadowRadius = 5.0
        self.viewStatusBarShadow.layer.cornerRadius = 3
        
//        let layer0 = CAGradientLayer()
//        layer0.frame = viewStatusBarGradient.bounds
//        layer0.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(0.0) ).cgColor]
//        layer0.startPoint = CGPoint(x: 0.5,y: 0.0)
//        layer0.endPoint = CGPoint(x: 0.5,y: 1.0)
//        viewStatusBarGradient.layer.addSublayer(layer0)
        
//        let layer = CAGradientLayer()
//        layer.frame = gradientViewForProfileView.bounds
//        layer.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(167/255.0), green: CGFloat(71/255.0), blue: CGFloat(201/255.0), alpha: CGFloat(1.0) ).cgColor]
//        layer.startPoint = CGPoint(x: 0.0,y: 1.0)
//        layer.endPoint = CGPoint(x: 1.0,y: 0.0)
//        gradientViewForProfileView.layer.addSublayer(layer)
        
        let layer1 = CAGradientLayer()
        layer1.frame = messageCalloutBtn.bounds
        layer1.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(167/255.0), green: CGFloat(71/255.0), blue: CGFloat(201/255.0), alpha: CGFloat(1.0) ).cgColor]
        layer1.startPoint = CGPoint(x: 0.0,y: 1.0)
        layer1.endPoint = CGPoint(x: 1.0,y: 0.0)
        messageCalloutBtn.layer.addSublayer(layer1)
        //messageCalloutBtn.setTitle("Send Message", for: .normal)
        
        let layer2 = CAGradientLayer()
        layer2.frame = goBtnOutl.bounds
        //layer2.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(151/255.0), green: CGFloat(140/255.0), blue: CGFloat(248/255.0), alpha: CGFloat(1.0) ).cgColor]
        layer2.colors = [UIColor( red: CGFloat(66/255.0), green: CGFloat(45/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0) ).cgColor, UIColor( red: CGFloat(167/255.0), green: CGFloat(71/255.0), blue: CGFloat(201/255.0), alpha: CGFloat(1.0) ).cgColor]
        layer2.startPoint = CGPoint(x: 0.0,y: 1.0)
        layer2.endPoint = CGPoint(x: 1.0,y: 0.0)
        goBtnOutl.layer.addSublayer(layer2)
        //goBtnOutl.setTitle("Set", for: .normal)
        
    }
    
    var FcmTimer = Timer()
    func runFcmTimer(){
        self.FcmTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        //FCM Token
        let uid = Auth.auth().currentUser?.uid
        let token = Messaging.messaging().fcmToken
        print(token)
        if token != nil {
            Database.database().reference().child("fcmTokens").child(uid!).setValue(["token": token!])
        } else {
            print("Token Error")
        }
        self.FcmTimer.invalidate()
        //
    
    }
    
    func checkIfUserIsLoggedIn() {
        print("Current User:")
        print(Auth.auth().currentUser)
        if Auth.auth().currentUser?.uid == nil {
            
            print("LOGOUT")
            self.handleLogout()
        } else {
            print(Auth.auth().currentUser?.uid)
                    print("LOGIN")
            
            
                    self.runFcmTimer()
                    self.showMyLocation()
                    self.loadPoints()
                    self.setCornerLayers()
                    self.setPropertiesForProfileView()
                    self.checkInternetConnectionInVC()
            
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("CHECK")
                print(snapshot.value)
                let value = snapshot.value as? NSDictionary
                
                DispatchQueue.main.async {
                    
                    // self.profileImageView.layer.cornerRadius = 60
                    // self.profileImageView.layer.masksToBounds = true
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
 
    
    @IBOutlet weak var hamburgerBtnOutl: UIButton!
    
    @IBOutlet weak var profileImageOutlet: UIImageView!
    
    
    @IBAction func exitToLoginButton(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.profileImageOutlet.alpha = 0.4
        }) { (Bool) in
            self.profileImageOutlet.alpha = 1
        }
        
//        UIView.animate(withDuration: 0.4){
//            self.mainViewProfileViewOut.alpha = 1
//        }
        
//        UIView.animate(withDuration: 0.4){
//            self.viewMenuBar.alpha = 0
//        }
        
        // open profile View
        
        guard let vc: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileController") as? ProfileViewController else {
            
            print("View controller could not be instantiated")
            return
        }
        
        vc.self.transferUid = Auth.auth().currentUser!.uid
        
        present(vc, animated: true, completion: nil)
        
        
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

    
    @IBAction func cancelBntAction(_ sender: Any) {
        mainSettingsWithoutLocation()
    }
    
    
    @IBOutlet weak var goBtnOutl: UIButton!
    @IBOutlet weak var pointNameLabel: UILabel!
    @IBOutlet weak var pointTimeLabel: UILabel!
    @IBOutlet weak var messageCalloutBtn: UIButton!
    @IBOutlet weak var pointTypelabel: UILabel!
    
    @IBOutlet weak var pointIntervalLabel: UILabel!
    
    @IBOutlet weak var pointViewsLabel: UILabel!
    
    @IBOutlet weak var pointLeftlabel: UILabel!
    
    @IBOutlet weak var pointLevelLabel: UILabel!
    
    
    func showMessageView(){
        if self.cardViewController.alpha == 1
        {
        self.cardViewController.alpha = 0
        }
        UIView.animate(withDuration: 0.8){
            self.cardViewController.alpha = 1
        }
        UIView.animate(withDuration: 0.4){
            self.viewMenuBar.alpha = 0
        }
    }
    
    
    
    func showPointView() {
      
        UIView.animate(withDuration: 0.4){
            self.cardViewController2.alpha = 1
        }
            UIView.animate(withDuration: 0.4){
                self.viewImagePin.alpha = 1
            }
        UIView.animate(withDuration: 0.4){
            self.viewMenuBar.alpha = 0
        }
        
            
    }
    
   var getNameId: String!
    var getpointIdFromMapView: String!
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        

        
        self.messageImageViewOutlet.image = UIImage(named: "DefaultProfileImage")
        if let ownerID = view.annotation?.subtitle! {
            let currentUserID = Auth.auth().currentUser?.uid
            self.messageCalloutBtn.alpha = 0
            self.deletePointBtnOut.alpha = 0
            
        self.getpointIdFromMapView = view.annotation?.subtitle!
        let ref = Database.database().reference().child("points").child(ownerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? [String : AnyObject]
            self.getNameId = value?["idOwner"] as? String
          
            if (Auth.auth().currentUser?.uid != self.getNameId!) {
                self.messageCalloutBtn.alpha = 1

                print("IF")
            }
            else {
                self.deletePointBtnOut.alpha = 1
                print("ELSE")
            }
            
            
            
            Database.database().reference().child("users").child(self.getNameId!).observeSingleEvent(of: .value, with: {(snapshot) in
                let value1 = snapshot.value as? [String : AnyObject]
                self.pointNameLabel.text = value1?["username"] as? String
                if let userImageUrl = value1?["profileImageUrl"] as? String {
                    self.messageImageViewOutlet.loadImageUsingCatchWithUrlString(urlString: userImageUrl)
                } else {
                   self.messageImageViewOutlet.image = UIImage(named: "DefaultProfileImage")
                }
           
            })
            
            
            //check time start
            
            let pointtimeStamp = value?["timestamp"] as? NSNumber
            //let pointTimeStampPlus24Hours = pointtimeStamp!.intValue + 86400
            let currentTimeStampDouble = (Date().timeIntervalSince1970) as Double
            let currentTimeStampInt:Int = Int(currentTimeStampDouble)
            var pointTimeStampPlus24Hours = pointtimeStamp!.intValue + 86400
            let timePointAdded = pointTimeStampPlus24Hours - currentTimeStampInt
            print(timePointAdded)
            let timePointAddedInHours = timePointAdded / 3600
            
            if (timePointAddedInHours < 1) {
                var minutesPointAdded = (timePointAdded % 3600) / 60
                if (minutesPointAdded == 0) {minutesPointAdded = 1}
                self.pointLeftlabel.text = (String(minutesPointAdded) + " Min")
                print(minutesPointAdded, "minutes")
            } else {
                self.pointLeftlabel.text = (String(timePointAddedInHours) + " Hr")
                print(timePointAddedInHours, "hours")
            }
           
            
            //check time end
            
            self.pointTimeLabel.text = value?["time"] as? String
            self.pointTypelabel.text = value?["type"] as? String
            self.pointIntervalLabel.text = value?["interval"] as? String
            self.pointLevelLabel.text = value?["level"] as? String
            let pointViews = value?["views"] as? Int
            //print(pointViews)
            self.pointViewsLabel.text = String(describing: pointViews!)
            let lLat = value?["lLat"] as? Double
            let lLong = value?["lLong"] as? Double
            print(lLat,lLong)
            let coordinate = CLLocationCoordinate2D(latitude: lLat!, longitude: lLong!)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            
            if (Auth.auth().currentUser?.uid != self.getNameId!) {
                 // add views start

                let numbersTimestamp = value?["timestamp"] as? NSNumber
                var views = value?["views"] as? Int
                views = views! + 1
                print(views, " VIEWS+1")
                let stringInterval = self.pointIntervalLabel.text
                let stringType = self.pointTypelabel.text
                let stringLevel = self.pointLevelLabel.text
                let stringTime = self.pointTimeLabel.text
                Database.database().reference().child("points").child(ownerID).setValue(["idOwner": self.getNameId,"time": stringTime, "type": stringType, "level": stringLevel,"interval": stringInterval, "lLat": lLat, "lLong": lLong, "timestamp": numbersTimestamp, "views": views!] as [String : Any])

                // add views end
                print("Updated views")
            }

            
            DispatchQueue.main.async {
                self.mapKitView.setRegion(region, animated: true)
                self.showMessageView()
            }
        })
        
            
        } else {
            print("annotationPin.subtitle = nil")
            
        }
        
        
        
    }
    
    
    @IBOutlet weak var locationImageOutlet: UIImageView!
    
    @IBAction func myLocationBtn(_ sender: Any) {
       showMyLocation()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.locationImageOutlet.alpha = 0.4
        }) { (Bool) in
            self.locationImageOutlet.alpha = 1
        }
        
    }
    
    func mainSettingsWithoutLocation(){
     self.checkInternetConnectionInVC()
        self.timerCheckIfUserHasPoin()

            UIView.animate(withDuration: 0.4){
                self.cardViewController.alpha = 0
            }
        
        UIView.animate(withDuration: 0.4){
            self.cardViewController2.alpha = 0
        }
    

        
     
            UIView.animate(withDuration: 0.4){
                self.viewImagePin.alpha = 0
            }
        
        UIView.animate(withDuration: 0.4){
            self.mainViewProfileViewOut.alpha = 0
        }
        
        deletePointBtnOut.alpha = 0
     
    }
    

    
    @IBAction func closeCardViewController(_ sender: Any) {
        mainSettingsWithoutLocation()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        navigationController?.navigationBar.barStyle = .blackOpaque
//    }
    
    @IBAction func sendMessageToFirebase(_ sender: Any) {
        
       // Database.database().reference()
        let toId = self.getNameId
        
        let fromId = Auth.auth().currentUser?.uid
        let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
        let values = ["text": "Lets do train", "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        let childRef = Database.database().reference().child("messages").childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
        
            }
            
            
            guard let messageId = childRef.key else { return }
            Database.database().reference().child("user-messages").child(fromId!).child(toId!).updateChildValues([messageId: 1])
            Database.database().reference().child("user-messages").child(toId!).child(fromId!).updateChildValues([messageId: 1])
//                let userMessageRef = Database.database().reference().child("user-messages").child(fromId!).child(toId!)
//                let messageId = childRef.key
//                print(messageId)
//                print("MESSAGEID")
//            userMessageRef.updateChildValues([messageId: 1]){ (error, ref) in
//                if error != nil {
//                    print(error)
//                    return
//
//                }}
            
//                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!).child(fromId!)
//            recipientUserMessagesRef.updateChildValues([messageId: 1]){ (error, ref) in
//                if error != nil {
//                    print(error)
//                    return
//
//                }}
                print(messageId)
                print("MESSAGEID")
                self.showMessageConroller()
                
            
           
        
        }
        
        
        
    }
// PROFILE VIEW
    
    @IBOutlet weak var cancelBtnForProfileViewOut: UIButton!
    @IBOutlet weak var imageProfileViewOut: UIImageView!
    @IBOutlet weak var userNameProfileViewOut: UITextField!
    @IBOutlet weak var mainViewProfileViewOut: UIView!
    @IBOutlet weak var secondWhiteProfileView: UIView!
    
    @IBOutlet weak var usernameProfileViewOut: UITextField!
    
    @IBOutlet weak var townProfileViewOut: UILabel!
    
    @IBOutlet weak var bioTextFieldProfileViewOut: UITextView!
    
    @IBOutlet weak var view1pxForShadow3: UIView!
    
    
    func setPropertiesForProfileView(){
        
        mainViewProfileViewOut.layer.shadowColor = UIColor.black.cgColor
        mainViewProfileViewOut.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        mainViewProfileViewOut.layer.shadowOpacity = 0.2
        mainViewProfileViewOut.layer.shadowRadius = 5.0
        mainViewProfileViewOut.layer.masksToBounds = false
        
        bioTextFieldProfileViewOut.layer.shadowColor = UIColor.black.cgColor
        bioTextFieldProfileViewOut.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        bioTextFieldProfileViewOut.layer.shadowOpacity = 0.3
        bioTextFieldProfileViewOut.layer.shadowRadius = 3.0
        bioTextFieldProfileViewOut.layer.masksToBounds = false
        bioTextFieldProfileViewOut.layer.cornerRadius = 5

        view1pxForShadow3.layer.shadowColor = UIColor.black.cgColor
        view1pxForShadow3.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view1pxForShadow3.layer.shadowOpacity = 0.7
        view1pxForShadow3.layer.shadowRadius = 4.0
        
        //        let borderView = UIView()
//        borderView.backgroundColor = UIColor.black
//        borderView.layer.frame = bioTextFieldProfileViewOut.bounds
//        bioTextFieldProfileViewOut.addSubview(borderView)
        
        cancelBtnForProfileViewOut.layer.cornerRadius = 17
        cancelBtnForProfileViewOut.clipsToBounds = true
        
        secondWhiteProfileView.layer.cornerRadius = 12
        
        secondWhiteProfileView.clipsToBounds = true
        
        
//        imageProfileViewOut.layer.borderWidth = 1
//        imageProfileViewOut.layer.borderColor = UIColor.black.cgColor
        imageProfileViewOut.layer.cornerRadius = 60
        imageProfileViewOut.clipsToBounds = true
        
        let userId = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            
            self.usernameProfileViewOut.text = value?["username"] as? String
            if let userImageUrl = value?["profileImageUrl"] as? String {
                self.imageProfileViewOut.loadImageUsingCatchWithUrlString(urlString: userImageUrl)
            } else {
                 self.imageProfileViewOut.image = UIImage(named: "DefaultProfileImage")
            }
            self.bioTextFieldProfileViewOut.text = value?["bio"] as? String
            self.townProfileViewOut.text = value?["town"] as? String
        })
        
    }
    
    
    @IBOutlet weak var signOutBtnOutlet: UIButton!
    
    @IBAction func exitToLoginBtnProfileView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.signOutBtnOutlet.alpha = 0.4
        }) { (Bool) in
            self.signOutBtnOutlet.alpha = 1
        }
        
        let alertController = UIAlertController(title: "Sign out", message: "You sure you wanna out? Cancel and Ok.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
             self.handleLogout()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
        //handleLogout()
    
    }
    
    @IBAction func closeProfileViewBtn(_ sender: Any) {
        mainSettingsWithoutLocation()
    }
    
    func showMessageConroller(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = mainStoryboard.instantiateViewController(withIdentifier: "messageControllerId")
        present(loginController, animated: true, completion: nil)
    }
    
    @IBAction func showMyPoints(_ sender: Any) {
        
       // mapKitView.removeAnnotation(mapKitView?.annotations as! MKAnnotation)
        self.pins.removeAll()
        self.points.removeAll()
        let allAnnotations = self.mapKitView.annotations
        self.mapKitView.removeAnnotations(allAnnotations)
        
         let userID = Auth.auth().currentUser?.uid

        Database.database().reference().child("user-points").child(userID!).observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
          
        Database.database().reference().child("points").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? [String : AnyObject]
            let point = Point()
            point.idOwner = value?["idOwner"] as? String
            //point.time = value?["time"] as? String
            //point.type = value?["type"] as? String
            // let lLat = value?["lLat"] as? Double
            //  let lLong = value?["lLong"] as? Double
            // let key = snapshot.key
            let coordinate = CLLocationCoordinate2D(latitude: value?["lLat"] as! Double, longitude: value?["lLong"] as! Double)
            //self.pin = AnnotationPin(title: value?["idOwner"] as! String, subtitle: snapshot.key, coordinate: coordinate)
            self.pin = AnnotationPin(title: value?["type"] as! String, subtitle: snapshot.key, coordinate: coordinate)
            self.pins.append(self.pin)
            self.points.append(point)
            DispatchQueue.main.async {
                self.mapKitView.addAnnotations(self.pins)
            }
            
        }, withCancel: nil)
            }, withCancel: nil)
    
        allPointsBtnOut.alpha = 1
        myPointsBtnOut.alpha = 0
        
        let alertController = UIAlertController(title: "Look!", message: "All this points yours", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func showAllPoints(_ sender: Any) {
        self.loadPoints()
    
        allPointsBtnOut.alpha = 0
        myPointsBtnOut.alpha = 1
    
    }
    
    
    
    @IBOutlet weak var myPointsBtnOut: UIButton!
    @IBOutlet weak var allPointsBtnOut: UIButton!
    @IBOutlet weak var deletePointBtnOut: UIButton!
    @IBAction func deletePointBtn(_ sender: Any) {
        
        
        print(getpointIdFromMapView)
        Database.database().reference().child("points").child(getpointIdFromMapView).removeValue()
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("user-points").child(userID!).removeValue()
        self.loadPoints()
        self.mainSettingsWithoutLocation()
        
        let alertController = UIAlertController(title: "Deleted", message: "Your point deleted", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // picker view
    
    var typeTagForPicker = 0
    
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerData: [String] = [String]()
    let pickerDataType = ["Run", "Workout", "Yoga", "Bike", "Tennis"]
     let pickerDataLevel = ["Beginner", "Advanced", "Expert"]
     let pickerDataTime = ["5AM", "6AM", "7AM", "8AM", "9AM", "10AM", "11AM", "12PM", "1PM", "2PM", "3PM", "4PM" ,"5PM", "6PM", "7PM", "8PM", "9PM", "10PM", "11AM", "12PM", "1AM", "2AM"]
     let pickerDataInterval = ["10 Min.", "15 Min.", "30 Min.", "45 Min.", "60 Min.","1.5 Hr.", "2 Hrs."]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    @IBAction func btnChooseType(_ sender: Any) {
        typeTagForPicker = 1
        pickerData.removeAll()
        pickerData = pickerDataType
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
         pickerView.selectRow(1, inComponent: 0, animated: true)
        UIView.animate(withDuration: 0.4){
            self.outletPickerVisualEffectView.alpha = 1
        }
    }
    
    
    @IBAction func btnChooseLevel(_ sender: Any) {
        typeTagForPicker = 2
        pickerData.removeAll()
        pickerData = pickerDataLevel
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
         pickerView.selectRow(1, inComponent: 0, animated: true)
        UIView.animate(withDuration: 0.4){
            self.outletPickerVisualEffectView.alpha = 1
        }
    }
    
    @IBAction func btnChooseTime(_ sender: Any) {
        typeTagForPicker = 3
        pickerData.removeAll()
        pickerData = pickerDataTime
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
         pickerView.selectRow(1, inComponent: 0, animated: true)
        UIView.animate(withDuration: 0.4){
            self.outletPickerVisualEffectView.alpha = 1
        }
    }
    
    @IBAction func btnChooseInterval(_ sender: Any) {
        typeTagForPicker = 4
        pickerData.removeAll()
        pickerData = pickerDataInterval
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
        pickerView.selectRow(1, inComponent: 0, animated: true)
        UIView.animate(withDuration: 0.4){
            self.outletPickerVisualEffectView.alpha = 1
        }
    }
    
    @IBOutlet weak var outletBtnType: UIButton!
    @IBOutlet weak var outletBtnLevel: UIButton!
    @IBOutlet weak var outletBtnTime: UIButton!
    @IBOutlet weak var outletBtnInterval: UIButton!
    
    @IBOutlet weak var outletPickerVisualEffectView: UIVisualEffectView!
    
    @IBAction func btnDonePicker(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4){
            self.outletPickerVisualEffectView.alpha = 0
        }
        
    }
    

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typeTagForPicker == 1 {outletBtnType.setTitle(pickerData[row], for: .normal)}
        if typeTagForPicker == 2 {outletBtnLevel.setTitle(pickerData[row], for: .normal)}
        if typeTagForPicker == 3 {outletBtnTime.setTitle(pickerData[row], for: .normal)}
        if typeTagForPicker == 4 {outletBtnInterval.setTitle(pickerData[row], for: .normal)}
    }
    
    //
    // END
    //

}
