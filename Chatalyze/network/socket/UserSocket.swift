//
//  UserSocket.swift
//  ICS
//
//  Created by Sumant Handa on 08/07/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit
import SocketIO
import PubNub

class UserSocket {
    
    fileprivate static var _sharedInstance : UserSocket?
    var socketManager : SocketManager?
    var socket : SocketIOClient?
    var pubnub = PubNub(configuration: PubNubConfiguration())
    var isRegisteredToServer = false
    private var notificationLogger = LogNotification()
    private var registrationTimeout = UserSocketRegistrationTimeout()
    
    init(){
        initialization()
    }
    
    deinit {
        pubnub.unsubscribeAll()
    }
    
    fileprivate func initialization(){
        
        initializeVariable()
        registerForAppState()
        initializeSocketConnection()
    }
    
    fileprivate func initializeVariable(){
        
        guard let socketURL = URL(string: AppConnectionConfig.userSocketURL)
            else{
                return
        }
        
        let manager = SocketManager(socketURL: socketURL, config: [.log(false), .forceNew(true)])
        let socket = manager.defaultSocket
        self.socketManager = manager
        self.socket = socket
    }
    
    fileprivate func registerForAppState(){
                        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    fileprivate func unregisterForAppState(){
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func appMovedToBackground() {
        Log.echo(key: "user_socket", text:"called appMovedToBackground")
        
        socketManager?.disconnect()
//        socket?.disconnect()
    }
    
    @objc func appMovedToForeground() {
        
        Log.echo(key: "user_socket", text:"appMovedToForeground")
        
        let userInfo = SignedUserInfo.sharedInstance
        Log.echo(key: "", text: "userData is =>\(String(describing: userInfo))")
        if(userInfo == nil){
           return
        }
        Log.echo(key: "user_socket", text:"connect request in appMovedToForeground")
        socketManager?.connect()
        socket?.connect()
        
    }
    
    static var sharedInstance : UserSocket?{
        
        if(_sharedInstance != nil){
            return _sharedInstance
        }
        
        _sharedInstance = UserSocket()
        return _sharedInstance
    }
    
    static var readInstance : UserSocket?{
        
        return UserSocket._sharedInstance
    }
}


//SOCKET CONNECTION
extension UserSocket{
    fileprivate func initializeSocketConnection(){
        
        socket?.on(clientEvent: .connect, callback: { (data, ack) in
          
            self.notificationLogger.notify(text : "connected :)")
            self.isRegisteredToServer = false
            Log.echo(key: "user_socket", text:"socket connected , the data is connect ==>\(data) and the acknowledgment is \(ack.expected)")
            DispatchQueue.main.async {
                self.registerSocket()
            }
        })
        
        socket?.on(clientEvent: .disconnect, callback: { (data, ack) in
            
            self.notificationLogger.notify(text : "disconnected :(")
            self.isRegisteredToServer = false
            Log.echo(key: "user_socket", text:"socket  (disconnect) => \(data)")
        })
        
        socket?.on(clientEvent: .error, callback: { (data, ack) in
            Log.echo(key: "user_socket", text:"socket error data (error) => \(data)")
        })
        
        
        socket?.on(clientEvent: .reconnectAttempt, callback: { (data, ack) in
            Log.echo(key: "user_socket", text:"socket reconnect => \(data)")
        })
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                Log.echo(key: "user_socket", text:"oh my God I am going back")
                return
        }
        pubnub.subscribe(to: ["login"+(userInfo.id ?? "")])
//        socket?.on("login") {[weak self] data, ack  in
//            Log.echo(key: "user_socket", text:"socket login data => \(data)")
//            self?.isRegisteredToServer = true
//
//            //
//            let dele = UIApplication.shared.delegate as? AppDelegate
//
//            dele?.earlyCallProcessor?.fetchInfo()
//            self?.registrationTimeout.cancelTimeout()
//            //Changing the color of online offline view
//        }
        
        // Create a new listener instance
        let listener = SubscriptionListener()

        // Add listener event callbacks
        listener.didReceiveSubscription = { event in
          switch event {
          case let .messageReceived(message):
            print("Message Received: \(message) Publisher: \(message.publisher ?? "defaultUUID")")
            self.isRegisteredToServer = true
            let dele = UIApplication.shared.delegate as? AppDelegate
            dele?.earlyCallProcessor?.fetchInfo()
            self.registrationTimeout.cancelTimeout()
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
        pubnub.add(listener)
        
        socket?.onAny({ (data) in
            
//            Log.echo(key: "user_socket", text: "onAny \(data)")
        })
        
        Log.echo(key: "user_socket", text:"connect request in initializeSocketConnection")
        
        socket?.connect()
    }

    
    func registerSocket(){
        
        Log.echo(key: "user_socket", text:"trying to register socket registerSocket")
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                Log.echo(key: "user_socket", text:"oh my God I am going back")
                return
        }
        var param = [String : Any]()
        param["uid"] = Int(userInfo.id ?? "")
        let info = param.JSONDescription()
        Log.echo(key: "user_socket", text: "info => " + info)
        Log.echo(key: "user_socket", text: "param => \(param)")
        let jsonString = param.JSONDescription()
        pubnub.publish(channel: "login", message: jsonString) { result in
          switch result {
          case let .success(timetoken):
            print("The message was successfully published at: \(timetoken)")
          case let .failure(error):
            print("Handle response error: \(error.localizedDescription)")
          }
        }
        registrationTimeout.registerForTimeout(seconds: 10.0) {[weak self] in
            
            guard let weakSelf = self
                else{
                    return
            }
            
            Log.echo(key: "user_socket", text: "re-register - Socket")
            //recursive call
            weakSelf.registerSocket()
        }
        
        Log.echo(key: "", text:"Connected and emitted")
    }
    
    func disconnect(){
        
        socket?.disconnect()
        socketManager?.disconnect()
        
        socket = nil
        socketManager = nil
        UserSocket._sharedInstance = nil
        unregisterForAppState()
    }
    
}
