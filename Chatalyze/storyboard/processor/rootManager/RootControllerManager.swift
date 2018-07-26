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
    
    func setRoot(){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        _ = appDelegate?.window
        delayLaunchScreen {
            self.showRelevantScreen()
        }
    }
    
    func updateRoot(){
        
        self.showRelevantScreen()
    }
    
    private func showRelevantScreen(){
        
        updateNavigationBar()
        let userInfo = SignedUserInfo.sharedInstance
        if(userInfo == nil){
            showSigninScreen()
            return
        }
        showHomeScreen()
        return
    }
    
    
    private func showSigninScreen(){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        
        guard let signinController = SigninController.instance()
            else{
                return
        }
        let signinNav : UINavigationController = ExtendedNavigationController()
        signinNav.viewControllers = [signinController]
        window?.rootViewController = signinNav
    }
    
    
    private func showHomeScreen(){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        let rootNav : UINavigationController = ExtendedNavigationController()
        
        /*guard let controller = EventQueueController.instance()
         else{
         return
         }*/
        
        Log.echo(key: "yud", text: "Root is active")
        let transition = CATransition()
        transition.type = kCATransitionFade
        //window?.set(rootViewController: rootNav, withTransition: transition)
        if let userInfo = SignedUserInfo.sharedInstance{
            if userInfo.role == .analyst{
                
                guard let containerController = ContainerController.instance() else {
                    return
                }
                window?.set(rootViewController: containerController, withTransition: transition)
                //window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
                initializeAppConnection()
                //**
//                guard let controller = HomeController.dynamicInstance()
//                    else{
//                        return
//                }
//                rootNav.viewControllers = [controller]
//                window?.set(rootViewController: rootNav, withTransition: transition)
//                window?.makeKeyAndVisible()
//                initializeAppConnection()
            }else{
                
                guard let containerController = ContainerController.instance() else {
                    return
                }
                window?.set(rootViewController: containerController, withTransition: transition)
                //window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
                initializeAppConnection()
            }
        }
    }
    
    private func updateNavigationBar(){
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = AppThemeConfig.navigationBarColor
        UINavigationBar.appearance().tintColor = AppThemeConfig.navigationBarColor
        UINavigationBar.appearance().barStyle = .black
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
    }
    
    func signOut(completion : (()->())?){
        
        SignedUserInfo.sharedInstance?.clear()
        UserSocket.sharedInstance?.disconnect()
        SocketClient.sharedInstance?.disconnect()
        RootControllerManager().updateRoot()
    }
    
    func getCurrentController()->ContainerController?{
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let root = appDelegate?.window?.rootViewController as? ContainerController
        return root
    }
    
}
