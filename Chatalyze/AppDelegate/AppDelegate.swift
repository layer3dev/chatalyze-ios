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
import FBSDKLoginKit
import SwiftyJSON
import StoreKit
import Bugsnag
import Analytics
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var allowRotate : Bool = false
    var isRootInitialize:Bool = false
    var shownEarlySessionIdList:[Int] = [Int]()
    var earlyCallProcessor:VerifyForEarlyCallProcessor?
    var isSignatureInCallisActive = false
    var signatureDirection:UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    var timer : SyncTimer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GIDSignIn.sharedInstance().clientID = "1084817921581-q7mnvrhvbsh3gkudbq52d47v2khle66s.apps.googleusercontent.com"
        SKPaymentQueue.default().add(InAppPurchaseObserver.sharedInstance)
        UNUserNotificationCenter.current().delegate = self
        initialization()
        bugSnagInitialization()
        initializeSegmentIO()
        disableAppToSwitchIntoSleepMode()
        test()
        registerForPushNotifications()
        handlePushNotification(launch:launchOptions)
        UIApplication.shared.registerForRemoteNotifications()
        timer = SyncTimer()
        self.startTimer()
        return true
    }
    
    fileprivate func bugSnagInitialization(){
        
        Bugsnag.start(withApiKey: AppConnectionConfig.bugsnagKey)
        
        if let id = SignedUserInfo.sharedInstance?.id {
        
            Bugsnag.configuration()?.setUser(id, withName: SignedUserInfo.sharedInstance?.fullName, andEmail: SignedUserInfo.sharedInstance?.email)
        }
        
        Bugsnag.configuration()?.reportBackgroundOOMs = false
    }

    fileprivate func initializeSegmentIO(){
        
        let configuration = SEGAnalyticsConfiguration.init(writeKey:AppConnectionConfig.segmentIOKey)
        configuration.trackApplicationLifecycleEvents = false
        configuration.recordScreenViews = false
        SEGAnalytics.setup(with: configuration)
    }
    
    fileprivate func test() {
        
        _ = Date().millisecondsSince1970
    }
    
    fileprivate func disableAppToSwitchIntoSleepMode(){
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    fileprivate func initialization(){
        
        _ = NavigationBarCustomizer()
        RootControllerManager().setRoot {
            self.isRootInitialize = true
        }
        _ = RTCConnectionInitializer()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("Application did enter to background.")
        
        Log.echo(key: "yud", text: "Application did enter to background.")

        timer?.pauseTimer()
        self.shownEarlySessionIdList.removeAll()

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.

        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

        print("Application will enter into the foreground.")
        
        Log.echo(key: "yud", text: "Application will enter into the foreground.")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        Log.echo(key: "yud", text: "ApplicationDidBecomeActive is calling")
//        setupNotifications()
        earlyCallProcessor?.eventInfoArray.removeAll()
        verifyingAccessToken()
        startTimer()
        
        if self.isRootInitialize{
            
            AppDelegate.fetchAppVersionInfoToServer()
        }
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    private func startTimer(){

        timer?.ping { [weak self] in
            self?.executeInterval()
        }
        
        timer?.startTimer()
    }
    
    func executeInterval(){

        guard let _ = SignedUserInfo.sharedInstance?.id else {
            return
        }
        if earlyCallProcessor == nil {
            earlyCallProcessor = VerifyForEarlyCallProcessor()
        }
        verifyForEarlyExistingCall()
    }
    
    func isAlreadyShownAlert(infoId:Int)->Bool{
        
        for id in shownEarlySessionIdList{
            if id == infoId {
                return true
            }
        }
        return false
    }
    
    func verifyForEarlyExistingCall(){

        guard let roleType = SignedUserInfo.sharedInstance?.role else{
            return
        }

        guard let accessToken = SignedUserInfo.sharedInstance?.accessToken else{
            return
        }

        if accessToken == "" {
            return
        }

        if roleType != .analyst{
            return
        }

        earlyCallProcessor?.verifyEarlyExistingCall { (info) in

            //Log.echo(key: "yud", text: "Data is fetched")

            if info != nil{

                guard let id = info?.id else{
                    return
                }

                if self.isAlreadyShownAlert(infoId:id){
                    return
                }

                if let controller = RootControllerManager().getCurrentController()?.presentedViewController as? EarlyCallAlertController{

                    self.shownEarlySessionIdList.append(id)
                    return
                }

                guard let controller = EarlyCallAlertController.instance() else{
                    return
                }
                controller.requiredDate = info?.startDate
                controller.info  = info

                Log.echo(key: "yud", text: "Presented in the HostDashboard UI")
                self.shownEarlySessionIdList.append(id)                
               
                
                controller.modalPresentationStyle = .fullScreen
                RootControllerManager().getCurrentController()?.present(controller, animated: true, completion: nil)
            }
        }
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        SKPaymentQueue.default().remove(InAppPurchaseObserver.sharedInstance)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) ->UIInterfaceOrientationMask {
        
        if isSignatureInCallisActive{
            
            return signatureDirection
        }
        
        if(allowRotate){
            return .allButUpsideDown
        }
        //Only allow portrait (standard behaviour)
        return .portrait
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *){
            
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
                
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
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
        Log.echo(key: "yud", text: "RemoteNotification userInfo is \(userInfo)")
        let aps = userInfo["aps"] as? [String: AnyObject]
        Log.echo(key: "yud", text: "RemoteNotification aps data \(String(describing: aps))")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // This method save the device token if shared intance alraedy exists else create new one with the data.
        _ = SessionDeviceInfo.getSharedIstance(deviceToken: token)
        // call function for the token Update
        self.updateToken()
        print("Device Token is : \(token)")
    }
    
    func updateToken(){
        
        guard let _ = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        RefreshDeviceToken().update { (success, message, response) in
            if !success{
                return
            }
            Log.echo(key: "yud", text: "Device token is updated successfully.")
        }
    }
    
    func application(_ application: UIApplication,                 didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: \(error)")
    }
    
    func handlePushNotification(launch:[UIApplication.LaunchOptionsKey: Any]?){
        
        if let notification = launch?[.remoteNotification] as? [AnyHashable: AnyObject] {
            
            PushNotificationHandler().handleNavigation(info: notification)
            if let aps = notification["aps"] as? [AnyHashable: AnyObject]{
            }
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return ApplicationDelegate.shared.application(app,open:url,options:options)
    }
}


extension AppDelegate {
    
    func verifyingAccessToken() {
        
        guard let userInfo = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        AccessTokenValidator().validate { (success) in

            if !success {
                
                RootControllerManager().signOut(completion: {
                })
            }
        }
    }
    
   static func fetchAppVersionInfoToServer(){
    
    //This will handle the case when app will open second time and root is already initialized.
    
    FetchAppVersionInfo().fetchInfo { (success, response) in
            
            if !success {
                
                HandlingAppVersion().checkForAlert()
                return
            }
            
            if let dict = response?.dictionary{
                
                let strLatestVersion = dict["current_app_version"]?.stringValue
                let strDeprecateVersion = dict["deprecated_version"]?.stringValue
                let strObsoleteVersion = dict["obsolete_version"]?.stringValue
                
                let latestVersion = Double(strLatestVersion ?? "")
                let deprecateVersion = Double(strDeprecateVersion ?? "")
                let obsoleteVersion = Double(strObsoleteVersion ?? "")
                
                //let obsoleteVersion = 1.00
                UserDefaults.standard.setValue(latestVersion ?? 0.0, forKey: "latestVersion")
                UserDefaults.standard.setValue(deprecateVersion ?? 0.0, forKey: "deprecateVersion")
                UserDefaults.standard.setValue(obsoleteVersion ?? 0.0, forKey: "obsoleteVersion")
                HandlingAppVersion().checkForAlert()
            }
        }
    }
}
