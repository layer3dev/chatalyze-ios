//
//  AppDelegate.swift
//  Chatalyze
//
//  Created by Sumant Handa on 21/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import GoogleSignIn
//import Stripe
import TwitterKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var allowRotate : Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Calling the delegate methods to the local notifications
        UNUserNotificationCenter.current().delegate = self
        initialization()
        test()
        registerForPushNotifications()
        handlePushNotification(launch:launchOptions)
        initializeTwitterKit()
        UIApplication.shared.registerForRemoteNotifications()
        return true
    }
    
    func initializeTwitterKit(){
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "N7JqWt4Sdhh8v7v2YoSsnFvCA", consumerSecret: "x1qgm8gLfTQpiWTtkwBJ6XQ2tXAs6yB9katZpguYG1LLQuhkRt")
    }
    
    fileprivate func test(){
        
        TimerSync.sharedInstance
    }
    
    fileprivate func initialization(){

        _ = NavigationBarCustomizer()
        
        RootControllerManager().setRoot {
            
            Log.echo(key: "yud", text: "I have setted the RootController Successfully")
        }
        _ = RTCConnectionInitializer()
    }
    
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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) ->
     
        UIInterfaceOrientationMask {           
            if(allowRotate){
                return .allButUpsideDown;
        }
        //Only allow portrait (standard behaviour)
        return .portrait;
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                
                Log.echo(key: "yud", text: "10.0 \(granted)")
                guard granted else{
                    return
                }
                self.getNotificationSettings()
            }
        }else{
            
            Log.echo(key: "yud", text: "Fallback version")
            //Fallback on earlier versions
        }
    }
    
    
    func getNotificationSettings() {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
              
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
               
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                print("Notification settings Registered: \(settings)")
            }
        }else{
            //Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert,.sound,.badge])
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        PushNotificationHandler().handleNavigation(info: response.notification.request.content.userInfo)
        let userInfo = response.notification.request.content.userInfo
        Log.echo(key: "yud", text: "remoteNotificatio userInfo is \(userInfo)")
        let aps = userInfo["aps"] as? [String: AnyObject]
        Log.echo(key: "yud", text: "RemoteNotification aps data \(String(describing: aps))")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        
        //This method save the device token if shared intance alraedy exists else create new one with the data
        _ = SessionDeviceInfo.getSharedIstance(deviceToken: token)
        //call function for the token Update
        self.updateToken()
        print("Device Token is : \(token)")
    }
    
    func updateToken(){
        
        RefreshDeviceToken().update { (success, message, response) in
            
            if !success{
                return
            }
            Log.echo(key: "yud", text: "Device token is updated successfully")
        }
    }
    
    func application(_ application: UIApplication,                 didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func handlePushNotification(launch:[UIApplicationLaunchOptionsKey: Any]?){
        
        if let notification = launch?[.remoteNotification] as? [AnyHashable: AnyObject] {
            
            PushNotificationHandler().handleNavigation(info: notification)
            if let aps = notification["aps"] as? [AnyHashable: AnyObject]{
                
                //PushNotificationHandler().handleNavigation(info: notification)
                Log.echo(key: "yud", text: "APS is \(aps)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //(app, open: url, options: options)

        return (GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || TWTRTwitter.sharedInstance().application(app,open:url,options:options)) || FBSDKApplicationDelegate.sharedInstance().application(app,open:url,options:options)
    }
}
