//
//  AppDelegate.swift
//  Wibree
//
//  Created by 村上幸雄 on 2016/09/27.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Document.sharedInstance.load()
        Connector.shared().addObserver(self,
                                       forKeyPath: "networkAccessing",
                                       options: NSKeyValueObservingOptions(rawValue: UInt(0)),
                                       context: nil)
        
        if #available(iOS 10.0, *) {
            let userNotificationCenter = UNUserNotificationCenter.current()
            userNotificationCenter.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {
                (granted, error) in
                if let e = error {
                    print(#function + "error(\(e))")
                }
                else if granted {
                    print(#function + "通知許可")
                }
                else {
                    print(#function + "通知拒否")
                }
            })
        } else {
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        Document.sharedInstance.save()
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

    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutableRawPointer) {
        if(keyPath == "networkAccessing"){
            _updateNetworkActivity()
        }
    }
    
    private func _updateNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = Connector.shared().isNetworkAccessing
    }

}

