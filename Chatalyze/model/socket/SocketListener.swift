//
//  SocketListener.swift
//  Chatalyze
//
//  Created by Sumant Handa on 03/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import Foundation
import Starscream
import SwiftyJSON


//connected with Ratchet
class SocketListener : NSObject{
    
    fileprivate var connectionCallbackList : [Int : (Bool)->()] = [Int : (Bool)->()]()
    fileprivate var newConnectionCallbackList : [Int : (Bool)->()] = [Int : (Bool)->()]()
    fileprivate var eventListenerList : [Int : SocketListenerCallback] = [Int : SocketListenerCallback]()
    private var identifier = 0
    fileprivate var connectionCounter = 0
    
    private var socketClient : SocketRootProtocol?
    
    
    
    init(identifier : Int, socketClient : SocketRootProtocol){
        self.socketClient = socketClient
        self.identifier = identifier
        super.init()
        initialization()
    }
    
    
    
    fileprivate func initialization(){
        
        initializeVariable()
        
    }
    
    
    fileprivate func initializeVariable(){
        
        
    }
    
    
    func confirmConnect(completion : ((_ success : Bool)->())?){
        guard let socketClient = socketClient
            else{
                completion?(false)
                return
        }
        let isConnected = socketClient.isSocketConnected
        if isConnected{
            Log.echo(key: "socket_client", text: "you are connected please continue")
            completion?(true)
            return
        }
        
        add() { (success) in
            completion?(success)
        }
        
    }
    
    fileprivate func add(listener : @escaping (_ connected : Bool)->()){
        
       let countdown = uniqueConnectionIdentifier
    connectionCallbackList[countdown] = listener
    }
    
    
    func updateAllForConnectionActive() {
        guard let socketClient = socketClient
            else{
                return
        }
       
        for (connectionCounter,callback) in connectionCallbackList {
            Log.echo(key: "socket", text: "Hey i'm connected")
            let isConnected = socketClient.isSocketConnected
            callback(isConnected)
            connectionCallbackList[connectionCounter] = nil
        }
    }
    
    var uniqueConnectionIdentifier : Int{
        connectionCounter = connectionCounter + 1
        return connectionCounter
    }
    
    func onEvent(_ action : String, completion : ((_ json : JSON?)->())?){
        let counter = uniqueConnectionIdentifier
        
        let callback = SocketListenerCallback(action: action, listener: completion)
        eventListenerList[counter] = callback
    }
    
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
    
    func updateForEvent(action : String, data : JSON?) {
        for (_,callback) in eventListenerList {
            if(callback.action != action){
                continue
            }
            callback.listener?(data)
        }
    }
    
    func newConnectionListener(completion : ((_ success : Bool)->())?){
        guard let socketClient = socketClient
            else{
                completion?(false)
                return
        }
        let isConnected = socketClient.isSocketConnected
        if isConnected{
            Log.echo(key: "socket", text: "you are connected please continue")
            completion?(true)
        }
        
        
        addToNewConnectionList() { (success) in
            completion?(success)
        }
        return
        
    }
    
    
    
    
    fileprivate func addToNewConnectionList(listener : @escaping (_ connected : Bool)->()){
        let identifier = uniqueConnectionIdentifier
    newConnectionCallbackList[identifier] = listener
    }
    
    func updateAllForNewConnection() {
        guard let socketClient = socketClient
            else{
                return
        }
        Log.echo(key: "socket_client", text: "the the world that you are connected now")
        for (connectionCounter,callback) in  newConnectionCallbackList {
            Log.echo(key: "socket", text: "Hey i'm connected")
            let isConnected = socketClient.isSocketConnected
            callback(isConnected)
            newConnectionCallbackList[connectionCounter] = nil
        }
    }
    
    
    @objc func clean(){
        connectionCallbackList.removeAll()
        newConnectionCallbackList.removeAll()
        eventListenerList.removeAll()
    }
    
    @objc func releaseListener(){
        clean()
        socketClient?.release(identifier: identifier)
        socketClient = nil
    }
    
}


