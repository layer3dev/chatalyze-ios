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
    fileprivate var connectionFlag = true
    
    override init(){
        super.init()
        initialization()
    }
    
    var isConnected : Bool{
        get{
            return isRegistered
        }
    }
    
    fileprivate func initialization(){
        initializeVariable()
        registerForAppState()
        initializeSocketConnection()
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
    }
    
    
    @objc func appMovedToForeground() {
        
        Log.echo(key: "socket_client", text:"appMovedToForeground")
        let userInfo = SignedUserInfo.sharedInstance
        if(userInfo == nil){
            return
        }
        
        if(!connectionFlag){
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


    @objc func connect(roomId : String){
        
         self.connectionFlag = true
         self.roomId = roomId
        
         socket?.connect()
    }
    
    func initializeSocketConnection(){
        socket?.onConnect = {
            Log.echo(key: "socket_client", text:"socket connected new")
            DispatchQueue.main.async {
                self.registerSocket()
            }
        }
        
        //websocketDidDisconnect
        socket?.onDisconnect = { (error: Error?) in
            self.isRegistered = false
            
            Log.echo(key: "socket_client", text:"socket websocketDidDisconnect")
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.5), execute: {
                if(self.connectionFlag){
                    self.socket?.connect()
                }
            })
            
        }
        
        
        self.onEvent("registerResponse") {data in
            Log.echo(key: "socket_client", text:"socket connected in registerResponse")
            
            let json = data?.rawString() ?? ""
            Log.echo(key: "registerResponse", text:json)
            
            let turnServerInfos = data?["servers"].arrayValue ?? [JSON]()
            TurnServerInfo.sharedInstance.fillInfos(infos: turnServerInfos)
            
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

        
    }

    

    fileprivate func registerSocket(){
        
        Log.echo(key: "socket_client", text:"socket registerSocket")
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        
        var param = [String : Any]()
        param["room"] = self.roomId
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
        
        Log.echo(key: "socket_client", text: "disconnect => called")
        connectionFlag = false
        resetListeners()
        socket?.disconnect() 
        
    }
    
    private func resetListeners(){
//        connectionCallbackList = [Int : (Bool)->()]()
//        eventListenerList = [Int : SocketListenerCallback]()
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
        
        
        var data = json["data"]
        if(data == nil){
            data = json
        }
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
    
    //supports both Swift and Objective C
    @objc func emit(id : String?, data : [String : Any]?){
        var params = [String : Any]()
        params["id"] = id
        params["data"] = data
        
        self.emit(params)
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
        
        Log.echo(key: "socket", text: "confirmConnect please")
        let isConnected = self.isRegistered
        if isConnected{
            Log.echo(key: "socket", text: "you are connected please continue")
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
        Log.echo(key: "socket", text: "the the world that you are connected now")
        for (connectionCounter,callback) in connectionCallbackList {
            Log.echo(key: "socket", text: "Hey i'm connected")
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





