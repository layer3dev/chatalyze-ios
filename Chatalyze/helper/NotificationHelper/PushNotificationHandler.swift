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
        
        case eventDelay = 0
        case eventStarted = 1
        case eventUpdatedStartTime = 2
        case eventCancelled = 3
        case privateEventTicket = 4
        case eventScheduledAgainForAnalyst = 5
        case remindForEvent = 6
        case none = 8
        
    }
    
    func getNotificationType(info:[AnyHashable:Any]?)->(notificationType)?{
        
        //return notificationType.eventStarted
        
        guard let info = info else {
            return nil
        }
        guard let notificationTypeString = info["activity_type"] as? String else{
            return nil
        }
        if notificationTypeString == "event_delayed"{
            
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.eventDelay
        }
        if notificationTypeString == "event_started"{
            
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.eventStarted
        }
        if notificationTypeString == "event_updated"{
        
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.eventUpdatedStartTime
        }
        if notificationTypeString == "event_canceled"{
            
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.eventCancelled
        }
        if notificationTypeString == "private_event_ticket"{
            
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.privateEventTicket
        }
        if notificationTypeString == "tickets_availble_again"{
            
            //user:- Session
            //same
            return notificationType.eventScheduledAgainForAnalyst
        }
        if notificationTypeString == "event_start_in_24_hours" || notificationTypeString == "event_start_in_30_mins" || notificationTypeString == "event_start_in_15_min"{
         
            //user:-My Tickets
            //Analyst:- My Session
            return notificationType.remindForEvent
        }
        return nil
    }
    
    
    @objc func handleNavigation(info : [AnyHashable : Any]?){
        
        guard let userInfo = SignedUserInfo.sharedInstance?.id else{
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
        
        guard let info = info else{
            return
        }
        
        guard let type = getNotificationType(info: info) else{
            return
        }
        
        if let role = SignedUserInfo.sharedInstance?.role{
            
            if role == .analyst{
                
                if type == .eventDelay {                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                if type == .eventStarted {
                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                if type == .eventUpdatedStartTime {
                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                if type == .eventCancelled{
                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                if type == .privateEventTicket{
                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                if type == .eventScheduledAgainForAnalyst{
                    
                    RootControllerManager().selectEventTabWithSessions()
                }
                if type == .remindForEvent{
                    
                    RootControllerManager().selectAccountTabWithScheduledSessionScreen()
                }
                return
            }
            
            //If the user role is USER
            if type == .eventDelay {
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .eventStarted {
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .eventUpdatedStartTime {
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .eventCancelled{
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .privateEventTicket{
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .eventScheduledAgainForAnalyst{
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            if type == .remindForEvent{
                
                RootControllerManager().setMyTicketsScreenForNavigation()
            }
            return
        }
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
