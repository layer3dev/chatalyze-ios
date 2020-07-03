//
//  RootControllerManager.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import UIKit

class RootControllerManager{
    
    private let TAG = "RootControllerManager"
    
    func setRoot(didLoadWindow:(()->())?){
        
        Log.echo(key: TAG, text: "SET ROOT")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        _ = appDelegate?.window
        delayLaunchScreen {
            self.showRelevantScreen{
                Log.echo(key: self.TAG, text: "START VALIDATING")
                didLoadWindow?()
                ValidateDevice().showDeviceSupportWarningAlert {
                    
                }
                
            }
        }
    }
    
    
    
    func updateRoot(){
        
        self.showRelevantScreen {
        }
    }
    
    func isOnBoardShowed()->Bool{
        
        guard let onboardStatus =  UserDefaults.standard.value(forKey: "isOnBoardShowed") as? Bool else{
            return false
        }
        return onboardStatus
    }
    
    private func showRelevantScreen(didLoadWindow:(()->())?){
        
        let _ =  NavigationBarCustomizer()
        let userInfo = SignedUserInfo.sharedInstance
        if(userInfo == nil){
            Log.echo(key: self.TAG, text: "SHOW SIGNIN")
            showSigninScreen(didLoadWindow: didLoadWindow)
            AppDelegate.fetchAppVersionInfoToServer()
            //HandlingAppVersion().checkForAlert()
            return
        }
        if isOnBoardShowed(){
            Log.echo(key: self.TAG, text: "SHOW ONBOARD")
            showOnboardScreen(didLoadWindow:didLoadWindow)
            return
        }
        Log.echo(key: self.TAG, text: "SHOW HOME")
        showHomeScreen(didLoadWindow: didLoadWindow)
        AppDelegate.fetchAppVersionInfoToServer()
        //HandlingAppVersion().checkForAlert()
        return
    }
    
    
    private func showOnboardScreen(didLoadWindow:(()->())?){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        //let rootNav : UINavigationController = ExtendedNavigationController()
        Log.echo(key: "yud", text: "Root is active")
        let transition = CATransition()
        transition.type = CATransitionType.fade
        
        Log.echo(key: "yud", text: "onboard am host with role if \(SignedUserInfo.sharedInstance?.role)and the roleID is \(SignedUserInfo.sharedInstance?.roleId) and the signed Info is is \(SignedUserInfo.sharedInstance?.id)")

        if let userInfo = SignedUserInfo.sharedInstance{
            if userInfo.role == .analyst{
                
                Log.echo(key: "yud", text: "I am host with role if \(userInfo.role)and the roleID is \(userInfo.roleId) and the signed Info is is \(SignedUserInfo.sharedInstance?.id)")
                
                
//                guard let onboardController = OnBoardFlowController.instance() else {
//                    return
//                }
//                onboardController.didLoad = didLoadWindow
//                window?.set(rootViewController: onboardController, withTransition: transition)
//                window?.makeKeyAndVisible()
//                initializeAppConnection()
                
                showHomeScreen(didLoadWindow: didLoadWindow)
            }else{
                
                Log.echo(key: "yud", text: "I am user with roleTYpe \(userInfo.role) and the roleID is \(userInfo.roleId) signed Info is is \(SignedUserInfo.sharedInstance?.id)")

                guard let onboardController = OnBoardFlowController.instance() else {
                    return
                }
                onboardController.didLoad = didLoadWindow
                window?.rootViewController = onboardController
                window?.makeKeyAndVisible()
                initializeAppConnection()
            }
        }
    }
    
    private func showSigninScreen(didLoadWindow:(()->())?){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window        

        guard let signinController = LoginSignUpContainerController.instance()
            else{
                return
        }
        signinController.didLoad = didLoadWindow
        let signinNav : UINavigationController = ExtendedNavigationController()
        signinNav.viewControllers = [signinController]
        window?.rootViewController = signinNav
    }
    
    private func showHomeScreen(didLoadWindow:(()->())?){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        let _ : UINavigationController = ExtendedNavigationController()
        Log.echo(key: "yud", text: "Root is active")
        let transition = CATransition()
        transition.type = CATransitionType.fade
        
        if let userInfo = SignedUserInfo.sharedInstance{
      
            Log.echo(key: "yud", text: "I am user with roleTYpe \(userInfo.role) and the roleID is \(userInfo.roleId) signed Info is is \(SignedUserInfo.sharedInstance?.id)")
            
            if userInfo.role == .analyst{
                
                guard let containerController = ContainerController.instance() else {
                    return
                }
                containerController.didLoad = didLoadWindow
                window?.rootViewController = containerController
                window?.makeKeyAndVisible()
                initializeAppConnection()
                
            }else{
                
                guard let containerController = ContainerController.instance() else {
                    return
                }
                containerController.didLoad = didLoadWindow
                window?.rootViewController = containerController
                window?.makeKeyAndVisible()
                initializeAppConnection()
                
                Log.echo(key: self.TAG, text: "DID SHOW HOME")
            }
        }
    }
    
    
    fileprivate func delayLaunchScreen(completion : @escaping (()->())){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        window?.rootViewController = LaunchDelayController.instance()
        let when = DispatchTime.now() + 1
        //change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion()
            return
        }
    }
    
    private func initializeAppConnection(){
        _ = UserSocket.sharedInstance
        //UserSocket.sharedInstance?.registerSocket()
    }
    
    func signOut(completion : (()->())?){
    
        SignedUserInfo.sharedInstance?.clear()
        resetEarlyCallAlert()
        UserSocket.sharedInstance?.disconnect()
        SocketClient.sharedInstance?.disconnect()
        RootControllerManager().updateRoot()
    }
    
    func resetEarlyCallAlert(){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.shownEarlySessionIdList.removeAll()
        appDelegate?.earlyCallProcessor = nil
    }
    
    func getCurrentController()->ContainerController?{
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let root = appDelegate?.window?.rootViewController as? ContainerController
        return root
    }
    
    func setMyTicketsScreenForNavigation(){
        
        if let rootController = getCurrentController(){
            rootController.selectAccountTabWithTicketScreen()
        }
    }
    
    func selectAccountTabWithScheduledSessionScreen(){
        
        if let rootController = getCurrentController(){
            rootController.setAccountTabwithMySessionScreen()
        }
    }
    
    func selectEventTabWithSessions(){
        
        if let rootController = getCurrentController(){
            rootController.selectEventTabWithSessions()
        }
    }
    
    func navigateToScheduleSessionController(){
        
        if let rootController = getCurrentController(){
            rootController.setMySessions()
        }
    }
}
