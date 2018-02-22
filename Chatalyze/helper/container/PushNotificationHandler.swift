//
//  PushNotificationHandler.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 02/06/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON

class PushNotificationHandler{
    
    func push(json : JSON?){
        
        ContainerController.initialTab = .greeting
        
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else{
                return
        }
        let window = appDelegate.window
        guard let root = window?.rootViewController as? ContainerController
        else{
            return
        }
        
        root.selectTab(type: .greeting)
        NotificationCenter.default.post(name:NSNotification.Name("pushNotify"), object: nil)
    }
    
    private func handlePush(controller : ContainerController){
    }
}
