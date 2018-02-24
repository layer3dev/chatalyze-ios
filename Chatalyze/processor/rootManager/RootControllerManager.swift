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
    
    
    
    
}
