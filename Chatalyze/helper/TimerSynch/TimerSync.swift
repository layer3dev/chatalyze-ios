//
//  TimerSync.swift
//  Chatalyze
//
//  Created by Sumant Handa on 17/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimerSync {
    
    private var syncTime : Date?

    var timeDiff : Int64 = Int64(0);
    var resyncTime = 60 * 1000
    var precision = 0
    var maxCountRequest = 3
    
    var isSynced = false
    
    private var countRequest = 0; //current Request Count status
    private var requestIdentifierCounter : Int = 0
    
    private var thresholdPrecisionAccuracy = 250; //minimum accuracy required from response
    
    private var requestTime = Date()
    private let countdown = CountdownListener()
    private let socket = SocketClient.sharedInstance
    private var socketListener : SocketListener?
    
   static var sharedInstance : TimerSync{
    
        get{
            if let shared = _sharedInstance{
                return shared
            }
            
            let sharedNew = TimerSync()
            _sharedInstance = sharedNew
            return sharedNew
        }
    }
    
    private static var _sharedInstance : TimerSync?
    
    
    init() {
        initialization()
    }
    
    
    private func initialization(){
        initializeVariable()
        syncListener()
        setServerListener()
        sync()        
    }
    
    private func initializeVariable(){
        socketListener = socket?.createListener()
    }
    
    
    
    private func syncListener(){
        countdown.add { [weak self] in
            self?.sync()
        }
    }
    
    
    func sync(){
        
        if(!(socket?.isBridged ?? false)){
//            Log.echo(key: "sync socket", text: "not connected")
            return
        }
        
        if let syncTime = self.syncTime{
            let lastSyncTimestamp = syncTime.millisecondsSince1970
            let timestampNow = Date().millisecondsSince1970
            if(timestampNow - lastSyncTimestamp <= resyncTime){
                return;
            }
        }
       
        self.countRequest = 0
        self.precision = 0;
        syncTime = Date()
        //executeSync()
        
    }
    
    
    
    
//    private func executeSync(){
//        requestTime = Date()
//        requestIdentifierCounter = requestIdentifierCounter + 1
//
//        var message = [String : Any]()
//        message["id"] = "getTimestamp"
//        message["requestIdentifier"] = requestIdentifierCounter
//
//        socket?.emit(message)
//
//    }
    
    private func setServerListener(){
        
        UserSocket.sharedInstance?.pubnub.time { result in
            switch result {
            case let .success(timetoken):
                let requiredTimeStamp = timetoken / 10000
                var timeJson: JSON? = JSON()
                timeJson?["timestamp"] = JSON(requiredTimeStamp)
                
                let syncInfo = TimeSyncInfo(info: timeJson)
                let isSynced = self.updateTimeDifference(info : syncInfo)
                self.isSynced = true
                if(self.countRequest > self.maxCountRequest || isSynced){
                    return
                }
                
                self.countRequest = self.countRequest + 1
              print("timestamp13345 pubnub \(requiredTimeStamp)")
            case let .failure(error):
              print("Handle response error: \(error.localizedDescription)")
            }
          }

        
        
        
//        socketListener?.onEvent("timestamp", completion: {[weak self] (json) in
//
//            Log.echo(key: "timestamp", text: "json -> \(String(describing: json?.rawString()))")
//
//            guard let weakSelf = self
//                else{
//                    return
//            }
//
//            let syncInfo = TimeSyncInfo(info: json)
//            let isSynced = weakSelf.updateTimeDifference(info : syncInfo)
//            self?.isSynced = true
//            if(weakSelf.countRequest > weakSelf.maxCountRequest || isSynced){
//                return
//            }
//
//            weakSelf.countRequest = weakSelf.countRequest + 1
//            weakSelf.executeSync()
//        })
    }
    
    
    private func getTime()->Int64{
        let currentDate = Date()
        
        if(timeDiff == 0){
            return currentDate.millisecondsSince1970
        }
        
        return currentDate.millisecondsSince1970 + Int64(self.timeDiff)
    }
    
    
    func getSeconds()->Int{
        let milliSeconds = self.getTime()
        let seconds = Int(milliSeconds/1000)
        
        return seconds
    }
    
    func getDate()->Date{
      
        let seconds = getSeconds()
        return Date.init(seconds : seconds)
    }
   
    private func updateTimeDifference(info : TimeSyncInfo)->Bool{
        syncTime = Date()
        let responseTime = Date()
        
        if(!info.isValid()){
            return false
        }
        
        if(info.identifier != requestIdentifierCounter){
            return false
        }
        
        let precision = Int((responseTime.millisecondsSince1970 - requestTime.millisecondsSince1970)/2)
        let timeDiff =
        Int64(info.timestamp) + Int64(precision) - responseTime.millisecondsSince1970
        if(self.precision == 0){
            self.precision = precision
            self.timeDiff = timeDiff
        }
        
        if(precision < self.precision){
            self.precision = precision
            self.timeDiff = timeDiff
        }
        
        Log.echo(key: "precision", text: "precision -> \(precision) -> timeDiff -> \(timeDiff)")
        
        Log.echo(key: "precision", text: "self.precision -> \(self.precision) -> self.timeDiff -> \(self.timeDiff)")
        
        if(precision > thresholdPrecisionAccuracy){
            return false
        }
        
        return true
    }
}
