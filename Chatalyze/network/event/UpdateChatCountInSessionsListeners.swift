//
//  UpdateChatCountInSessionsListeners.swift
//  Chatalyze
//
//  Created by Mansa on 26/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import PubNub

class UpdateChatCountInSessionsListeners{
    
    private let TAG = "UpdateChatCountInSessionListeners"
    
    private var listener : ((Int?)->())?
    
    init(){
        initializeListener()
    }
    
    deinit {
        guard let userInfo = SignedUserInfo.sharedInstance else {
            Log.echo(key: "user_socket", text:"oh my God I am going back")
            return
        }
        UserSocket.sharedInstance?.pubnub.unsubscribe(from: ["notification"+(userInfo.id ?? "")])
    }
    
    func setListener(listener : ((Int?)->())?){
        self.listener = listener
    }
    
    func initializeListener(){
        guard let userInfo = SignedUserInfo.sharedInstance else {
            Log.echo(key: "user_socket", text:"oh my God I am going back")
            return
        }
        UserSocket.sharedInstance?.pubnub.subscribe(to: ["notification"+(userInfo.id ?? "")])
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
        
        guard let callScheduleId  = metaInfo.callScheduleId
            else{
                return
        }
        
        
        if(activityType != .slotBooked){
            return
        }
        
        Log.echo(key: TAG, text: "notification -> \(rawInfo)")
        
        listener?(callScheduleId)
    }
}
