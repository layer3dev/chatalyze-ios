 //
//  PushNotificationHandler.swift
//  Chatalyze
//
//  Created by Mansa on 04/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
 
 @objc class PushNotificationHandler: NSObject {
    
    @objc enum notificationType : Int{
        
        case chat = 0
        case whistle = 1
        case view = 2
        case match = 3
        case newjoin = 4
        case hotprofile = 5
        case onesidedlike = 6
        case discussion = 7
        case none = 8
    }
    
    func getNotificationType(info:[AnyHashable:Any]?)->(notificationType)?{
        
        guard let info = info else {
            return nil
        }
        
        guard let notificationTypeString = info["gcm.notification.type"] as? String else{
            return nil
        }
        
        if notificationTypeString == "discussion"{
            return notificationType.discussion
        }
        return nil
    }
    
    
    @objc func handleNavigation(info : [AnyHashable : Any]?){
        
        let userInfo = UserDefaults.standard.value(forKey: "id")
        if(userInfo == nil){
            return
        }
        guard let info = info
            else{
                return
        }
        navigate(info: info)
    }
    
    fileprivate func navigate(info : [AnyHashable : Any]?){
        
        let controller = getRootController()
        if(controller == nil){
            
            RootControllerManager().setRoot {
                
                let root = self.getRootController()
                self.navigateWith(controller: root, info: info)
            }
            return
        }
        let root = getRootController()
        self.navigateWith(controller: root, info: info)        
    }
    
    fileprivate func navigateWith(controller : ContainerController?, info : [AnyHashable : Any]?){
        
//        guard let info = info else{
//            return
//        }
//
//        guard let navigationController = controller.getHomeNavigationController()
//            else{
//                return
//        }
//
//        guard let notification = getNotificationType(info: info) else{
//            return
//        }
//
//        guard let eventId = info["gcm.notification.event_id"] else {
//            return
//        }
//
//
//        if notification == notificationType.discussion{
//
//            let arrayCont:[UIViewController] = navigationController.viewControllers
//            var existingController:[UIViewController] = [UIViewController]()
//            for index in 0..<arrayCont.count{
//
//                if arrayCont[index].isKind(of: ActivityInfoController.classForCoder()){
//                    continue
//                }
//                if arrayCont[index].isKind(of: DiscussionController.classForCoder()){
//                    continue
//                }
//                existingController.append(arrayCont[index])
//            }
//
//            if let actvityInfoController = ActivityInfoController.instance(){
//
//                actvityInfoController.activity_id = "\(eventId)"
//                if let discussionInfoController = DiscussionController.instance(){
//                    RootControllerManager().getRootController()?.showHomeTab()
//
//                    discussionInfoController.activity_id = "\(eventId)"
//                    existingController.append(actvityInfoController)
//                    existingController.append(discussionInfoController)
//                    navigationController.setViewControllers(existingController, animated: true)
//                }
//            }
//        }
//
//
//        guard let tabController = controller.tabController else{
//            return
//        }
        //        tabController.selectedIndex = 0
        //        controller.resetTab()
        //        controller.homeLabel?.textColor = UIColor(red: 242.0/255.0, green: 95.0/255.0, blue: 62.0/255.0, alpha: 1)
        //        //controller.tabContainerView?.selectTab(type: .home)
        //        //navigationController.popToRootViewController(animated: true)
        //
        //            guard let cont = ActivityInfoController.instance() else {
        //                return
        //            }
        //            cont.activity_id = ""
        //            navigationController.pushViewController(cont, animated: true)
    }
    
    
    fileprivate func getRootController()->ContainerController?{
        
        guard let appDelegate = UIApplication.shared.delegate as?AppDelegate
            else{
                return nil
        }
        let window = appDelegate.window
        let rootController = window?.rootViewController as? ContainerController
        return rootController
    }
 }
