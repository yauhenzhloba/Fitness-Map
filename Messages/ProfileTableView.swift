//
//  ProfileTableView.swift
//  YogaFit
//
//  Created by EUGENE on 09.07.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableView: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.barTintColor = UIColor.yellow
        
        self.navigationItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLogChatController)))
       // navigationController?.navigationBar.barStyle = .default
        messages.removeAll()
        messagesDictionary.removeAll()
        
        
        self.observeUserMessages()

        

        
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Open Sans", size: 17)!]
                //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
                self.navigationController?.navigationBar.barTintColor = UIColor.white
        
//        UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdObserve", for: indexPath) as! TableViewCellForObserveMsg
        //self.tableView.separatorStyle = .none
        
        let message = self.messages[indexPath.row]
//        cell.contentViewForMessages.layer.shadowColor = UIColor.black.cgColor
//        cell.contentViewForMessages.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        cell.contentViewForMessages.layer.shadowOpacity = 0.4
//        cell.contentViewForMessages.layer.shadowRadius = 4.0
//        cell.contentViewForMessages.layer.cornerRadius = 7
        
        
        
        if let id = message.chatPartnerId() {
            
            let ref = Database.database().reference().child("users").child(id)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                cell.fromIdLabelObserve.text = value?["username"] as? String
                
                
                
                if let profileImageUrl = value?["profileImageUrl"] as? String {
                    
                   cell.profileImageObserve.layer.cornerRadius = 25
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            
            let chatLogControllerProgrammatically = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogControllerProgrammatically.userFromSegue = user
            self.navigationController?.pushViewController(chatLogControllerProgrammatically, animated: true)
           
        }, withCancel: nil)
        print("MESSAGE")
        print(message.text, message.fromId, message.toId)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
