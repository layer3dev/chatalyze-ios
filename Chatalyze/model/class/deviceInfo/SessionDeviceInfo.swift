//
//  SessionDeviceInfo.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 31/05/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON

class SessionDeviceInfo: DeviceInfo , NSCoding{
    
    private static var _sharedInstance : SessionDeviceInfo?
    
    static var sharedInstance : SessionDeviceInfo?{
        get{
            if(_sharedInstance != nil){
                return _sharedInstance
            }
            
            let instance = retreiveInstance()
            _sharedInstance = instance
            return instance
        }
    }
    static let encodingKey = "deviceInfo"
    
    static func getSharedIstance(deviceToken : String)->SessionDeviceInfo{
        
        if let instance = sharedInstance{
            instance.deviceToken = deviceToken
            instance.save()
            return instance
        }
        
        let instance = initSharedInstance(deviceToken: deviceToken)
        return instance
    }
    
   private static func initSharedInstance(deviceToken : String)->SessionDeviceInfo{
        
        let info = SessionDeviceInfo()
        info.deviceToken = deviceToken
        info.deviceId = UUID().uuidString
        _sharedInstance = info
        info.save()
        return info
    }
    
    override init(){
        super.init()
    }
    
    func save(){
        
        let ud = UserDefaults.standard
        let instance = self
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        ud.set(data, forKey: SessionDeviceInfo.encodingKey)
    }
    
    private static func retreiveInstance()->SessionDeviceInfo?{
        
        let ud = UserDefaults.standard
        guard let data = ud.object(forKey: encodingKey) as? Data
            else{
                return nil
        }
        
        let unarc = NSKeyedUnarchiver(forReadingWith: data)
        unarc.setClass(SessionDeviceInfo.self, forClassName: "SessionDeviceInfo")
        let signedUserInfo = unarc.decodeObject(forKey: "root") as? SessionDeviceInfo
        return signedUserInfo
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        deviceId = aDecoder.decodeObject(forKey: "deviceId") as? String
        deviceToken = aDecoder.decodeObject(forKey: "deviceToken") as? String
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(deviceId, forKey: "deviceId")
        aCoder.encode(deviceToken, forKey: "deviceToken")
    }
    
    func clear(){
        
        let ud = UserDefaults.standard
        ud.set(nil, forKey: SessionDeviceInfo.encodingKey)
        ud.synchronize()
        SessionDeviceInfo._sharedInstance = nil
    }
    
}

