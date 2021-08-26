//
//  UpdateEventListener.swift
//  Chatalyze
//
//  Created by Mansa on 02/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import PubNub

class UpdateEventListener{
    
    private let TAG = "UpdateEventListener"
    
    private var listener : (()->())?
    
    private var isReleased = false
    
    func releaseListener(){
        listener = nil
        isReleased = true
    }
    
    init(){
        initializeListener()
    }
    
    deinit {
        guard let userInfo = SignedUserInfo.sharedInstance else {
            Log.echo(key: "user_socket", text:"oh my God I am going back")
            return
        }
        let room = UserDefaults.standard.string(forKey: "room_id") ?? ""
        UserSocket.sharedInstance?.pubnub.unsubscribe(from: [("notification"+(userInfo.id ?? "")), "schedule_updated\(room)", "call_booked_success\(room)", "schedule_cancelled\(room)", "delayed\(room)", "NewChatalyzeEvent", "DeletedChatalyzeEvent"])
    }
    
    func setListener(listener : (()->())?){
        
        self.listener = listener
    }
    
    func initializeListener(){
        guard let userInfo = SignedUserInfo.sharedInstance else {
            Log.echo(key: "user_socket", text:"oh my God I am going back")
            return
        }
        let room = UserDefaults.standard.string(forKey: "room_id") ?? ""
        UserSocket.sharedInstance?.pubnub.subscribe(to: [("notification"+(userInfo.id ?? "")), "schedule_updated\(room)", "call_booked_success\(room)", "schedule_cancelled\(room)", "delayed\(room)", "NewChatalyzeEvent", "DeletedChatalyzeEvent"])
        // Create a new listener instance
        let listener = SubscriptionListener()

        // Add listener event callbacks
        listener.didReceiveSubscription = { event in
          switch event {
          case let .messageReceived(message):
            print("Message Received: \(message) Publisher: \(message.publisher ?? "defaultUUID")")
            guard let info = message.payload.rawValue as? [String : Any]
            else{
                return
            }
            self.processNotificationForNewSlot(info: info)
          case let .connectionStatusChanged(status):
            print("Status Received: \(status)")
          case let .presenceChanged(presence):
            print("Presence Received: \(presence)")
          case let .subscribeError(error):
            print("Subscription Error \(error)")
          default:
            break
          }
        }

        // Start receiving subscription events
        UserSocket.sharedInstance?.pubnub.add(listener)
    }

    private func processNotificationForNewSlot(info : [String : Any]){
        
        let rawInfosString = info.JSONDescription()
        
        
        guard let data = rawInfosString.data(using: .utf8)
            else{
                return
        }
        
        
        guard let rawInfo = try? JSON(data : data)
            else{
                return
        }
        
        let info = NotificationInfo(info: rawInfo)
        
        guard let metaInfo = info.metaInfo
            else{
                return
        }
        
        guard let activityType = info.metaInfo?.type
            else{
                return
        }
        
        
        if !(activityType == .schedule_updated || activityType == .updatedCallSchedule || activityType == .eventDelay  || activityType == .eventChatDurationUpdated){
            Log.echo(key: "vijayUpdate", text: "event type is\(activityType)")
            return
        }
        
        
        if(isReleased){
            return
        }
        
        if activityType == .eventChatDurationUpdated{
            HostCallController().showToastWithMessage(text: "Chat Extended Successfully".localized() ?? "", time: 5.0)
        }
        
        Log.echo(key: TAG, text: "notification -> \(rawInfo)")
        
        
        listener?()
    }
}
