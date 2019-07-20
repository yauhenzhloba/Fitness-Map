//
//  Message.swift
//  YogaFit
//
//  Created by EUGENE on 09.07.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    func chatPartnerId() -> String? {
        
        //let chatPartnerId: String?
        if fromId == Auth.auth().currentUser?.uid {
            // print("toId")
            return toId
        } else {
            // print("fromId")
            return fromId
        }
    }
    
    //    init(dictionary: [String: AnyObject]){
    //        super.init()
    //        fromId = dictionary["fromId"] as? String
    //        text = dictionary["text"] as? String
    //        timeStamp = dictionary["timeStamp"] as? NSNumber
    //        toId = dictionary["toId"] as? String
    //
    //        imageUrl = dictionary["imageUrl"] as? String
    //        imageWidth = dictionary["imageWidth"] as? NSNumber
    //        imageHeight = dictionary["imageHeight"] as? NSNumber
    //    }
    
}
