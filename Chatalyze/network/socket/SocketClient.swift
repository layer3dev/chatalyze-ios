//
//  SocketClient.swift
//  ICS
//
//  Created by Sumant Handa on 08/07/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON
//connected with Ratchet
class SocketClient : NSObject{
    
    fileprivate static var _sharedInstance : SocketClient?
    var socket : WebSocket?
    
    fileprivate var connectionCallbackList : [Int : (Bool)->()] = [Int : (Bool)->()]()
    fileprivate var eventListenerList : [Int : SocketListenerCallback] = [Int : SocketListenerCallback]()
    
    fileprivate var connectionCounter = 0
    
    var roomId : String = "0"

    
    fileprivate var isRegistered = false
    override init(){
        super.init()
        initialization()
    }
    
    fileprivate func initialization(){
        initializeVariable()
        registerForAppState()
//        initializeSocketConnection()
    }
    
    
    fileprivate func initializeVariable(){
        Log.echo(key: "socket_client", text:"initializeVariable WebSocket")
        
        guard let url = URL(string: AppConnectionConfig.socketURL)
            else{
                return
        }
        
        socket = WebSocket(url: url)
        registerForEvent()
    }
    
    
    fileprivate func registerForAppState(){
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func appMovedToBackground() {
        
        Log.echo(key: "socket_client", text:"appMovedToBackground")
//        socket?.disconnect()
    }
    
    
    @objc func appMovedToForeground() {
        
        Log.echo(key: "socket_client", text:"appMovedToForeground")
        let userInfo = SignedUserInfo.sharedInstance
        if(userInfo == nil){
            return
        }
        
        guard let socket = self.socket
            else{
                return
        }
        
        if(socket.isConnected){
            return
        }
        socket.connect()
    }
    
    
    @objc static var sharedInstance : SocketClient?{
        
        if(_sharedInstance != nil){
            return _sharedInstance
        }
        _sharedInstance = SocketClient()
        return _sharedInstance
    }
    
    static var readInstance : SocketClient?{
        return SocketClient._sharedInstance
    }
    
}

//SOCKET CONNECTION
extension SocketClient{
    
    //{"id":"register","name":"chedddiicdaibdia","room":"call-821","type":"participant","data":{"uid":9,"name":"gunjot mansa  "}}
    @objc func initializeSocketConnection(roomId : String){
        
        self.roomId = roomId
    
        socket?.onConnect = {
            Log.echo(key: "socket_client", text:"socket connected")
            DispatchQueue.main.async {
                self.registerSocket(roomId : roomId)
            }
        }
        
        //websocketDidDisconnect
        socket?.onDisconnect = { (error: Error?) in
            self.isRegistered = false
            
            Log.echo(key: "socket_client", text:"socket websocketDidDisconnect")
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.5), execute: {
                self.socket?.connect()
            })
            
        }
        
        self.onEvent("register") {data in
            Log.echo(key: "socket_client", text:"socket connected in register")
            DispatchQueue.main.async {
//                self.registerSocket()
            }
        }
        
        self.onEvent("registerResponse") {data in
            Log.echo(key: "socket_client", text:"socket connected in registerResponse")
            DispatchQueue.main.async {
                self.isRegistered = true
                //self.testCall()
                self.updateAllForConnectionActive()
            }
        }
        
        
        
        
        self.onEvent("error") {data in
            Log.echo(key: "socket_client", text:"socket error data => \(String(describing: data))")
            self.reconnect()
        }
        
        self.onEvent("notification") {data in
            Log.echo(key: "socket_client", text:"socket notification => \(String(describing: data))")
        }
 
       
        
        Log.echo(key: "socket_client", text:"user socket connecting")
        socket?.connect()
        
    }

    
//{"id":"register","name":"chedddiicdaibdia","room":"call-821","type":"participant","data":{"uid":9,"name":"gunjot mansa  "}}
    fileprivate func registerSocket(roomId : String){
        
        Log.echo(key: "socket_client", text:"socket registerSocket")
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        var param = [String : Any]()
        param["room"] = roomId
        param["name"] = userInfo.hashedId
        param["type"] = "participant"
        
        var data = [String : Any]()
        data["uid"] = Int(userInfo.id ?? "")
        data["name"] = "guest user"
        
        param["id"] = "register"
        param["data"] = data
        
        let info = param.JSONDescription()
        Log.echo(key: "socket_client", text: "info => " + info)
    

        directEmit(param)
    }
    
    
    func disconnect(){
        socket?.disconnect()
        socket = nil
        SocketClient._sharedInstance = nil
    }
    
    
    func reconnect(){
        //socket?.disconnect()
        //Log.echo(key: "socket_client", text:"tearup and make new")
        //socket?.connect()
    }
}



//receive
extension SocketClient{
    
    
    fileprivate func testCall(){
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        var param = [String : Any]()
        param["userId"] = userId;
        param["receiverId"] = userId;

        self.emit("testCallNotification", param)
    }
    
    
    fileprivate func registerForEvent(){
        
        self.socket?.onText = { (text: String) in
             DispatchQueue.main.async {
                Log.echo(key : "socket_client", text : "Received text: \(text)")
                guard let data = text.data(using: .utf8)
                    else{
                        return
                }
                
                let json = try? JSON(data : data)
                self.handleEventResponse(json: json)
                return
             }
        }
    }
    
    fileprivate func handleEventResponse(json : JSON?){
        guard let json = json
            else{
                return
        }
        
        let responseAction = json["id"].stringValue
        
        
        let data = json["data"]
        updateForEvent(action: responseAction, data: data)
        return
        
    }
}

//emit
extension SocketClient{
    
    func directEmit(_ data : [String : Any]?){
        self.directEmit("message", data)
    }
    
    func directEmit(_ action : String?, _ data : [String : Any]?){
        var params = [String : Any]()
        params["event"] = action
        params["data"] = data?.JSONDescription()
        sendWrapped(params, waitForConnection: false)
    }
    
    
    //for supporting objective C
    @objc func emitSupport(data : [String : Any]?){
        self.emitSupport(action: "message", data: data)
    }
    
    //for supporting objective C
    @objc func emitSupport(action : String, data : [String : Any]?){
        self.emit(action, data)
    }
    
    
    func emit(_ data : [String : Any]?){
        emit("message", data)
    }
    
    func emit(_ action : String?, _ data : [String : Any]?){
        var params = [String : Any]()
        params["event"] = action
        params["data"] = data?.JSONDescription()
        sendWrapped(params)
    }
    
    
    fileprivate func sendWrapped(_ data : [String : Any]?, waitForConnection : Bool = true){
        
        let jsonString = data?.JSONDescription() ?? ""
        Log.echo(key : "socket_client", text : "sendWrapped: \(jsonString)")
        
        if(!waitForConnection){
            self.socket?.write(string: jsonString)
            return
        }
        
        confirmConnect { (success) in
           
            self.socket?.write(string: jsonString)
        }
    }
}


//emit
//connectionWait
extension SocketClient{
    
    func confirmConnect(completion : ((_ success : Bool)->())?){
        let isConnected = self.isRegistered
        if isConnected{
            completion?(true)
            return
        }
        
        let countdown = connectionCounter
        connectionCounter = connectionCounter + 1
        
        add(connectionCounter: countdown) { (success) in
            completion?(success)
        }
        
    }
    
    fileprivate func add(connectionCounter : Int, listener : @escaping (_ connected : Bool)->()){
        connectionCallbackList[connectionCounter] = listener
    }
    
    
    fileprivate func updateAllForConnectionActive() {
        for (connectionCounter,callback) in connectionCallbackList {
            let isConnected = self.isRegistered
            callback(isConnected)
            connectionCallbackList[connectionCounter] = nil
        }
    }
    
}



//emit
//connectionWait
extension SocketClient{
    
    @objc func onEventSupport(action : String, completion : @escaping (_ rawData : [String : Any]?)->()){
        self.onEvent(action) { (json) in
            guard let data = json?.dictionaryObject
                else{
                    return
            }
            
            completion(data)
            return
        }
    }

    
    func onEvent(_ action : String, completion : ((_ json : JSON?)->())?){
        let counter = connectionCounter
        connectionCounter = connectionCounter + 1
        
        let callback = SocketListenerCallback(action: action, listener: completion)
        
        eventListenerList[counter] = callback
    }
    
    
    fileprivate func updateForEvent(action : String, data : JSON?) {
        for (_,callback) in eventListenerList {
            if(callback.action != action){
                continue
            }
            callback.listener?(data)
        }
    }
    
    
}





