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
    
    fileprivate var listenerInfo = [Int : SocketListener]()
    
    fileprivate var selfListener : SocketListener?
    
    fileprivate var connectionCounter = 0
    
    var socketDisconnect:(()->())?
    
    var roomId : String = "0"

    fileprivate var isRegistered = false
   
    fileprivate var connectionFlag = false
    
    override init(){
        super.init()
        initialization()
    }
    
    var isConnected : Bool{
        get{
            return isBridged && isRegistered
        }
    }
    
    var isInstantiated : Bool{
        return connectionFlag
    }
    
    @objc func createListener()->SocketListener{
        
        let identifier = uniqueConnectionIdentifier
        let listener = SocketListener(identifier : identifier, socketClient : self)
                
        listenerInfo[identifier] = listener
        return listener
    }
    
    fileprivate func initialization(){
        
        
        initializeVariable()
        registerForAppState()
        initializeSocketConnection()
    }
    
    
    fileprivate func initializeVariable(){
        
        Log.echo(key: "timestamp", text:"initializeVariable WebSocket")
        guard let url = URL(string: AppConnectionConfig.socketURL)
            else{
                return
        }
        self.selfListener = self.createListener()
        socket = WebSocket(url: url)
        registerForEvent()
    }
    
    
    fileprivate func registerForAppState(){
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        
        Log.echo(key: "timestamp", text:"appMovedToBackground")
    }
    
    
    @objc func appMovedToForeground() {
        
        Log.echo(key: "timestamp", text:"appMovedToForeground")
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
        Log.echo(key: "SocketClient", text: "connect called")
        
        if(roomId == self.roomId && isBridged && connectionFlag){
            return;
        }
        
        self.connectionFlag = true
        self.roomId = roomId
        
        if(isBridged){
            breakForReconnect()
            return
        }
        
        socket?.connect()
    }
    
    func ensureConnection(){
        if(isInstantiated){
            return
        }
        connect(roomId: "###")
        return
    }
    
    var isBridged : Bool{
        get{
            return socket?.isConnected ?? false
        }
    }
    
    func initializeSocketConnection(){
        
        socket?.onConnect = {
            Log.echo(key: "timestamp", text:"socket connected new")
            DispatchQueue.main.async {
                self.registerSocket()
            }
        }
        
        
        
        //websocketDidDisconnect
        socket?.onDisconnect = { (error: Error?) in
            self.isRegistered = false
            self.socketDisconnect?()
            Log.echo(key: "timestamp", text:"socket websocketDidDisconnect")
            DispatchQueue.main.asyncAfter(deadline: (.now() + 0.5), execute: {
                
                if(self.connectionFlag){
                    self.socket?.connect()
                }
            })
            
        }
        
        
        selfListener?.onEvent("registerResponse") {data in
            Log.echo(key: "timestamp", text:"socket connected in registerResponse")
            
            let json = data?.rawString() ?? ""
            Log.echo(key: "registerResponse", text:json)
            
            let turnServerInfos = data?["servers"].arrayValue ?? [JSON]()
            TurnServerInfo.sharedInstance.fillInfos(infos: turnServerInfos)
            
            DispatchQueue.main.async {
                self.isRegistered = true
                //self.testCall()
                self.updateAllForConnectionActive()
                self.updateAllForNewConnection()
            }
        }
        
         selfListener?.onEvent("error") {data in
            
            Log.echo(key: "timestamp", text:"socket error data => \(String(describing: data))")
            self.reconnect()
        }
        
         selfListener?.onEvent("notification") {data in
            Log.echo(key: "timestamp", text:"socket notification => \(String(describing: data))")
        }
        
    }

    

    fileprivate func registerSocket(){
        
        Log.echo(key: "timestamp", text:"socket registerSocket")
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                return
        }
        
        let userType = userInfo.role == .analyst ? "analyst" : "participant"
        
        var param = [String : Any]()
        param["room"] = self.roomId
        param["name"] = userInfo.hashedId
        param["type"] = userType
        
        var data = [String : Any]()
        data["uid"] = Int(userInfo.id ?? "")
        data["name"] = userInfo.fullName
        
        param["id"] = "register"
        param["data"] = data
        
        let info = param.JSONDescription()
        Log.echo(key: "timestamp", text: "info => " + info)
            directEmit(param)
    }
    
    
    func disconnect(){
        
        Log.echo(key: "timestamp", text: "disconnect => called")
        connectionFlag = false
        socket?.disconnect()
    }
    
    func breakForReconnect(){
        socket?.disconnect()
    }
    
    
    
    private func resetListeners(){

        //        connectionCallbackList = [Int : (Bool)->()]()
        //        eventListenerList = [Int : SocketListenerCallback]()
    }
    
    
    func reconnect(){
       
        //socket?.disconnect()
        //Log.echo(key: "timestamp", text:"tearup and make new")
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
            
            Log.echo(key: "_connection_", text: "text is \(text)")
             DispatchQueue.main.async {
                Log.echo(key : "_connection_", text : "Received text: \(text)")
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
        
        Log.echo(key: "handshake", text: "Response json is \(String(describing: json))")
        
        guard let json = json
            else{
                return
        }
        let responseAction = json["id"].stringValue
        var data = json["data"]
        if(data.dictionary == nil && data.array == nil){
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
        Log.echo(key : "_connection_", text : jsonString)
        
        if(!waitForConnection){
            self.socket?.write(string: jsonString)
            return
        }
        
        selfListener?.confirmConnect { (success) in
            self.socket?.write(string: jsonString)
        }
    }
}


//emit
//connectionWait
extension SocketClient{
    
    
    fileprivate func updateAllForConnectionActive() {
        
        Log.echo(key: "timestamp", text: "the the world that you are connected now")
        for (_,listener) in listenerInfo {
           listener.updateAllForConnectionActive()
        }
    }
    
    fileprivate func updateAllForNewConnection() {
        
        Log.echo(key: "timestamp", text: "new connection")
        for (_,listener) in listenerInfo {
            listener.updateAllForNewConnection()
        }
    }
    
    
    
}



//emit
//connectionWait
extension SocketClient{
    
    
    fileprivate func updateForEvent(action : String, data : JSON?) {
        
        for (_,listener) in listenerInfo {
            listener.updateForEvent(action: action, data: data)
        }
        
    }
    
    var uniqueConnectionIdentifier : Int{
        connectionCounter = connectionCounter + 1
        return connectionCounter
    }
    
}

extension SocketClient : SocketRootProtocol{
    var isSocketConnected : Bool{
        get{
            return isConnected
        }
    }
    
    func release(identifier : Int){
        listenerInfo[identifier] = nil
    }
}
