//
//  AppDelegate.swift
//  YogaFit
//
//  Created by EUGENE on 25.05.2018.
//  Copyright © 2018 Eugene Zloba. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
   // let gcmMessageIDKey = "gcm.message_id"
    // Fitness Map new features: Notifications

//    private var reachability:Reachability!;
//    
//    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
//    {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:"checkForReachability:", name: kReachabilityChangedNotification, object: nil);
//        
//        self.reachability = Reachability.reachabilityForInternetConnection();
//        self.reachability.startNotifier();
//    }
//    
//    func checkForReachability(notification:NSNotification)
//    {
//        // Remove the next two lines of code. You cannot instantiate the object
//        // you want to receive notifications from inside of the notification
//        // handler that is meant for the notifications it emits.
//        
//        //var networkReachability = Reachability.reachabilityForInternetConnection()
//        //networkReachability.startNotifier()
//        
//        let networkReachability = notification.object as Reachability;
//        var remoteHostStatus = networkReachability.currentReachabilityStatus()
//        
//        if (remoteHostStatus.value == NotReachable.value)
//        {
//            print("Not Reachable")
//        }
//        else if (remoteHostStatus.value == ReachableViaWiFi.value)
//        {
//            print("Reachable via Wifi")
//        }
//        else
//        {
//            print("Reachable")
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Override point for customization after application launch.
        //UITabBar.appearance().tintColor = UIColor.white
        GMSPlacesClient.provideAPIKey("AIzaSyBp0qtz5Sp6j0p7kNRg5PaN8rYtveYz8Iw")
        
//        UINavigationBar.appearance().barTintColor = UIColor.white
//        UINavigationBar.appearance().tintColor = UIColor.black
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
//        
        // AIzaSyBp0qtz5Sp6j0p7kNRg5PaN8rYtveYz8Iw
        // AIzaSyDfGMBIG6WvdZKUirb8aKz1SGNxvWA-J3Ida
        //UIApplication.shared.statusBarView?.backgroundColor = .red
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            //FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        
        return true
        
    }
    
    
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var token = ""
//        for i in 0..<deviceToken.count {
//            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//        }
//        print("Registration succeeded! Token: ", token)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
//
//        // custom code to handle push while app is in the foreground
//        print("Handle push from foreground\(notification.request.content.userInfo)")
//
//        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
//        let d : [String : Any] = dict["alert"] as! [String : Any]
//        let body : String = d["body"] as! String
//        let title : String = d["title"] as! String
//        print("Title:\(title) + body:\(body)")
//        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
//
//    }
//
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
//        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
//    }
//
//    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
//        window.rootViewController?.present(alert, animated: false, completion: nil)
//    }
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
//        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
//    }
//    
//    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
//        window.rootViewController?.present(alert, animated: false, completion: nil)
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }

}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}




//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        // Change this to your preferred presentation option
//        completionHandler([])
//    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }
//}

//extension AppDelegate: MessagingDelegate {
//
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Message data", remoteMessage.appData)
//    }
//
//
//}
