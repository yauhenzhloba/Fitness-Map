//
//  NewProfileTableViewVC.swift
//  YogaFit
//
//  Created by EUGENE on 1/28/19.
//  Copyright © 2019 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class NewProfileTableViewVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnCloseVC: UIButton!
    
    @IBOutlet weak var statusBarView: UIView!
    
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLogChatController)))
        messages.removeAll()
        messagesDictionary.removeAll()
        self.observeUserMessages()
        setupLayers()
    }
    
    func setupLayers(){
        btnCloseVC.layer.cornerRadius = 17
        
        statusBarView.layer.shadowColor = UIColor.black.cgColor
        statusBarView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        statusBarView.layer.shadowOpacity = 0.3
        statusBarView.layer.shadowRadius = 6.0
        statusBarView.layer.masksToBounds = false
        statusBarView.layer.cornerRadius = 6
    }
    
    func observeUserMessages() {
        print("observeUserMessages")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("Print message")
        print(uid)
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            //print(snapshot)
            let userId = snapshot.key
            print(userId)
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                let messageId = snapshot.key
                //print(messageId)
                self.fetchMessageWithMessageId(messageId: messageId)
                
            }, withCancel: nil)
            // return
            // self.fetchMessageWithMessageId(messageId: userId)
            
        })
        
    }
    
    
    
    
    
    private func fetchMessageWithMessageId(messageId: String){
        let mesagesReference = Database.database().reference().child("messages").child(messageId)
        
        mesagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            print("FETCH MESSAGE")
            print(snapshot)
            if let value = snapshot.value as? [String: AnyObject]  {
                let message = Message()
                
                message.fromId = value["fromId"] as? String
                message.text = value["text"] as? String
                message.timeStamp = value["timestamp"] as? NSNumber
                message.toId = value["toId"] as? String
                message.imageUrl = value["imageUrl"] as? String
                message.imageWidth = value["imageWidth"] as? NSNumber
                message.imageHeight = value["imageHeight"] as? NSNumber
                //print(message.imageUrl)
                self.messages.append(message)
                
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
                
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        //        DispatchQueue.main.async {
        //            self.tableView.reloadData()
        //        }
    }
    
    
    var timer: Timer?
    @objc func handleReloadTable(){
        self.messages = Array(self.messagesDictionary.values)
        // self.messages.sorted(by: { $0.timeStamp!.intValue > $1.timeStamp!.intValue })
        self.messages.sort(by: { (msg1, msg2) -> Bool in
            return msg1.timeStamp!.intValue > msg2.timeStamp!.intValue
        })
        DispatchQueue.main.async {
            print("we reloaded data")
            self.tableView.reloadData()
        }
    }
    //BTN FOR NEW MSG
    //    @IBAction func showLogChatBtn(_ sender: Any) {
    //        showLogChatController()
    //    }
    
    
    @objc func showLogChatController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "NewMessageVCID") as! UITableViewController
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NewProfileTableViewVC:UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCellIdObserve", for: indexPath) as! NewTableViewCell
        self.tableView.separatorStyle = .none
        
        cell.mainViewForTableViewCell.layer.shadowColor = UIColor.black.cgColor
        cell.mainViewForTableViewCell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cell.mainViewForTableViewCell.layer.shadowOpacity = 0.3
        cell.mainViewForTableViewCell.layer.shadowRadius = 3.0
        cell.mainViewForTableViewCell.layer.cornerRadius = 7
        
        
        
        let message = self.messages[indexPath.row]
        //print(message.timeStamp)
        
        
        
        if let id = message.chatPartnerId() {
            
            let ref = Database.database().reference().child("users").child(id)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                cell.fromIdLabelObserve.text = value?["username"] as? String
                
                
                
                if let profileImageUrl = value?["profileImageUrl"] as? String {
                    
                    cell.profileImageObserve.layer.cornerRadius = 30
                    cell.profileImageObserve.clipsToBounds = true
                    cell.profileImageObserve.loadImageUsingCatchWithUrlString(urlString: profileImageUrl)
                } else {
                    cell.profileImageObserve.image = UIImage(named: "DefaultProfileImage")
                }
                
                //print(message.timeStamp)
                
                if let seconds = message.timeStamp?.doubleValue {
                    let timestampDate = NSDate(timeIntervalSince1970: seconds)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    cell.timeStampLabelObserve.text = dateFormatter.string(from: timestampDate as Date)
                }
                cell.textLabelObserve.text = message.text
                
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TappedDidSelect")
        let message = messages[indexPath.row]

        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in

            let user = User()

            let value = snapshot.value as? NSDictionary
            user.id = snapshot.key
            user.id = chatPartnerId
            user.username = value?["username"] as? String
            user.email = value?["email"] as? String
            user.profileImageUrl = value?["profileImageUrl"] as? String

            let chatLogControllerProgrammatically = ChatLogControllerProgrammatically(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogControllerProgrammatically.userFromSegue = user

            //            let chatLogControllerProgrammatically:ChatLogControllerProgrammatically = ChatLogControllerProgrammatically()

            self.present(chatLogControllerProgrammatically, animated: true, completion: nil)
            //self.navigationController?.pushViewController(chatLogControllerProgrammatically, animated: true)

        }, withCancel: nil)
        print("MESSAGE")
        print(message.text, message.fromId, message.toId)
    }
    
}
