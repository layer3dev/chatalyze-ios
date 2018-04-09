//
//  UserSocket.swift
//  ICS
//
//  Created by Sumant Handa on 08/07/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit
import SocketIO

class UserSocket {
    
    fileprivate static var _sharedInstance : UserSocket?
    var socketManager : SocketManager?
    var socket : SocketIOClient?
    var isRegisteredToServer = false    
    
    init(){
        initialization()
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

        let manager = SocketManager(socketURL: socketURL, config: [.log(false)])
        let socket = manager.defaultSocket
        
        self.socketManager = manager
        self.socket = socket
    }
    
    fileprivate func registerForAppState(){
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func appMovedToBackground() {
        Log.echo(key: "user_socket", text:"appMovedToBackground")
        socket?.disconnect()
    }
    
    @objc func appMovedToForeground() {
        
        Log.echo(key: "user_socket", text:"appMovedToForeground")
        let userInfo = SignedUserInfo.sharedInstance
        Log.echo(key: "", text: "userData is =>\(userInfo)")
        if(userInfo == nil){
           return
        }
        Log.echo(key: "user_socket", text:"connect request in appMovedToForeground")        
        socket?.connect()
        
        //open func connect(timeoutAfter: Int, withHandler handler: (() -> Swift.Void)?)
        
//        socket?.connect(timeoutAfter: 5, withHandler: {
//            print("I don't connect")
//            self.appMovedToForeground()
//        })        
        
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
    
//    func disconnect(){
//        socket?.disconnect()
//    }
    
}

//SOCKET CONNECTION
extension UserSocket{
    fileprivate func initializeSocketConnection(){
        
        updateConnectionStatus(isConnected: false)
        socket?.on("connect") {data, ack in
            self.isRegisteredToServer = false
            Log.echo(key: "user_socket", text:"socket connected , the data is connect ==>\(data) and the acknowledgment is \(ack.expected)")
            DispatchQueue.main.async {
                self.registerSocket()
            }
        }
        
        socket?.on("login") {data, ack in
            Log.echo(key: "user_socket", text:"socket login data => \(data)")
            self.isRegisteredToServer = true
            self.updateConnectionStatus(isConnected: true)
        }
        
        socket?.on("disconnect") {data, ack in
            self.isRegisteredToServer = false
            Log.echo(key: "user_socket", text:"socket error data (disconnect) => \(data)")
            self.updateConnectionStatus(isConnected: false)
        }
        
        socket?.on("error") {data, ack in
            
            Log.echo(key: "user_socket", text:"socket error data (error) => \(data)")
            self.updateConnectionStatus(isConnected: false, isError: true)
            self.reconnect()
        }
        
        
        
        socket?.on("notification") {data, ack in
            
            Log.echo(key: "user_socket", text:"socket notification => \(data)")
        }
        
        socket?.on("reconnect"){data ,ack in
            self.isRegisteredToServer = false
            Log.echo(key: "", text: "I got recconnected in ON \(data)")
        
        }
        
        Log.echo(key: "user_socket", text:"connect request in initializeSocketConnection")
        socket?.connect()
    }
    
    fileprivate func registerSocket(){
        Log.echo(key: "user_socket", text:"socket registerSocket")
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        
        var param = [String : Any]()
        param["uid"] = Int(userInfo.id ?? "")
        let info = param.JSONDescription()
        Log.echo(key: "user_socket", text: "info => " + info)
        Log.echo(key: "user_socket", text: "param => \(param)")
        
        socket?.emit("login", param)
        
        
        
        /*socket?.emitWithAck("login", param).timingOut(after: 8) {data in
            if self.isRegisteredToServer != false{
                Log.echo(key: "", text: "Yessss I got connect!!")
            }else{
                self.registerSocket()
                Log.echo(key: "", text: "Oops Could not get connect Trying once again!!")
            }
         }*/
        Log.echo(key: "", text:"Connected and emitted")
//        socket?.emitWithAck("dsfds", param).timingOut(after: 5, callback: { (data) in
//            print("got ack in new TimeOut  with data: \(data)")
//        })
    }
    
    func disconnect(){
        socket?.disconnect()
        socket = nil
        UserSocket._sharedInstance = nil
    }
    
    func reconnect(){
        
    }
    
    fileprivate func redColorTransparency(){
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = UIColor.red
        UINavigationBar.appearance().tintColor = UIColor.red
       
    }
    
    fileprivate func grayColorTransparency(){
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = AppThemeConfig.navigationBarColor
        UINavigationBar.appearance().tintColor = AppThemeConfig.navigationBarColor
    }
    
    fileprivate func updateConnectionStatus(isConnected : Bool, isError : Bool = false){
        
        let themeColor =  AppThemeConfig.navigationBarColor
        let color = isConnected ? themeColor : UIColor.red

        UINavigationBar.appearance().backgroundColor = color
        UINavigationBar.appearance().tintColor = color
    }
    
}
