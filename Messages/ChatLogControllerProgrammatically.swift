//
//  ChatLogControllerProgrammatically.swift
//  YogaFit
//
//  Created by EUGENE on 10.07.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class ChatLogControllerProgrammatically: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let cellId = "cellId"
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var userFromSegue = User(){
        didSet {
            navigationItem.title = userFromSegue.username


        }
    }
    var messages = [Message]()
    var bottomSafeArea: CGFloat?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //var bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            bottomSafeArea = bottomLayoutGuide.length
        }
        print(bottomSafeArea, "BOTTOM SAFE AREA")
        // safe area values are now available to use
        
        
        
    }
    
    override func viewDidLoad() {
        
        //setupStatusBar()
        print("ChatViewControllerDidLoad")
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        navigationItem.title = userFromSegue.username
        collectionView?.backgroundColor = UIColor.white
        //collectionView?.register(ChatLogControllerCell(), forCellWithReuseIdentifier: cellId)
        // collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(ChatLogControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        observeMessages()
        //setupKeyboardObservers()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(dismissChat))
        navigationItem.leftBarButtonItem = button
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        self.view.addGestureRecognizer(tap)
        //self.view.addSubview(inputContainerView)
//        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
//        let guide = self.view.safeAreaLayoutGuide
//        //inputContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16).isActive = true
//        inputContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//        inputContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 16).isActive = true
//        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        guide.bottomAnchor.constraintEqualToSystemSpacingBelow(inputContainerView.bottomAnchor, multiplier: 1.0).isActive = true
//        
//        let guide2 = self.view.safeAreaLayoutGuide
//        guide2.bottomAnchor.constraintEqualToSystemSpacingBelow(self.collectionView!.bottomAnchor, multiplier: 1.0).isActive = true
        
        
        
        
        //self.view.addGestureRecognizer(tap)
    }
    
    func setupStatusBar(){
        
        var statusBarView = UIView()
        statusBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        statusBarView.backgroundColor = UIColor.blue
        statusBarView.clipsToBounds = true
        statusBarView.layer.cornerRadius = 5
        statusBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
               self.view.addSubview(statusBarView)
//                statusBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
//                statusBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//                statusBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 8).isActive = true
//                statusBarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
       // self.view.addSubview(statusBarView)
        
        var messageLabel = UILabel()
        messageLabel.text = "Username"
        messageLabel.backgroundColor = UIColor.black
        messageLabel.textColor = UIColor.white
        //messageLabel.frame = CGRect(x: 0, y: 0, width: statusBarView.frame.width, height: 21)
               statusBarView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "cancelicon10"), for: .normal)
        closeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        closeButton.layer.cornerRadius = 17
        closeButton.backgroundColor = UIColor.white
         statusBarView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.bottomAnchor.constraint(equalTo: statusBarView.bottomAnchor, constant: -16).isActive = true
        closeButton.leftAnchor.constraint(equalTo: messageLabel.rightAnchor, constant: 8).isActive = true
        closeButton.rightAnchor.constraint(equalTo: statusBarView.rightAnchor, constant: -16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        messageLabel.bottomAnchor.constraint(equalTo: statusBarView.bottomAnchor, constant: -16).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: statusBarView.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -8).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
      //  statusBarView.addSubview(messageLabel)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    @objc func dismissChat() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon10")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        //uploadImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        
        
        
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                              constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = UIColor.black
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 8).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: 3).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        return containerView
    }()
    
    @objc func handleUploadTap(){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    private func uploadToFirebaseStorageUsingImage(image: UIImage){
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_image").child("\(imageName).png")
        
        if let uploadata = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadata, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Failed to upload image:", error)
                    return
                }
                
                ref.downloadURL { (url, error) in
                    guard let imageUrl = url?.absoluteString else {
                        // Uh-oh, an error occurred!
                        return
                    }
                   
                    self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
                }
            }
            
        )
            
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    @objc func handleKeyboardDidShow(){
        if messages.count > 0 {
            timerScrollCollectionView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    

    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        conteinerViewBottomAnchor?.constant = -keyboardFrame!.height
    }
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        //let guide = view.safeAreaLayoutGuide



        conteinerViewBottomAnchor?.constant = 34.0

        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toId = self.userFromSegue.id else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                let value = snapshot.value as? [String : AnyObject]
                let message = Message()
                message.fromId = value?["fromId"] as? String
                message.text = value?["text"] as? String
                message.timeStamp = value?["timestamp"] as? NSNumber
                message.toId = value?["toId"] as? String
                message.imageUrl = value?["imageUrl"] as? String
                message.imageWidth = value?["imageWidth"] as? NSNumber
                message.imageHeight = value?["imageHeight"] as? NSNumber
                //                print("Observe Messges")
                //                print(message.imageUrl)
                //                print(message.text)
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
    private func timerScrollCollectionView(){

        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollCollectionView), userInfo: nil, repeats: false)

    }
    
    
    var timer: Timer?
    @objc func scrollCollectionView(){
        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogControllerCell
        
        //cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        setupCell(cell: cell, message: message)
        
        
        if let text = message.text{
            cell.textView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            
        }else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        return cell
    }
    
    private func setupCell(cell: ChatLogControllerCell, message: Message){
        
        if let profileImageUrl = self.userFromSegue.profileImageUrl {
            cell.profileImageView.loadImageUsingCatchWithUrlString(urlString: profileImageUrl)
        }
        
        if let messageImageUrl = message.imageUrl {
            
            //cell.profileImageView.loadImageUsingCatchWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.loadImageUsingCatchWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            // blue
            cell.bubbleView.backgroundColor = ChatLogControllerCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // gray
            cell.bubbleView.backgroundColor = UIColor(red: 240.0/255.0, green:
                240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        var message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var conteinerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleSend() {
        
        let toId = self.userFromSegue.id
        let fromId = Auth.auth().currentUser?.uid
        let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
        let values = ["text": inputTextField.text, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        let childRef = Database.database().reference().child("messages").childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.inputTextField.text = nil
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!).child(toId!)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!).child(fromId!)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
            
        }
        
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage){
        
        let toId = self.userFromSegue.id
        let fromId = Auth.auth().currentUser?.uid
        let timestamp: NSNumber = (Date().timeIntervalSince1970) as NSNumber
        let values = ["toId": toId, "fromId": fromId, "timestamp": timestamp, "imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        let childRef = Database.database().reference().child("messages").childByAutoId()
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            self.inputTextField.text = nil
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId!).child(toId!)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId!).child(fromId!)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    // custom zooming logic
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        if let keyWindow = UIApplication.shared.keyWindow{
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.backgroundColor = UIColor.black
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               // self.dismissKeyboard()
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                let height = (self.startingFrame?.height)! / (self.startingFrame?.width)! * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: { (completed) in
                // zoomOutImageView.removeFromSuperview()
            })
            
            
        }
    }
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                
            })
            
            
        }
    }
}
