//
//  ApplicationDeviceInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import DeviceKit


class DeviceApplicationInfo {
    
    func rawInfo()->[String : Any]{
      
//        let device = Device()
        let iOSVersion = UIDevice.current.systemVersion
        var info = [String : Any]()
        
        var osInfo = [String : Any]()
        osInfo["name"] = "iOS"
        osInfo["version"] = iOSVersion
        
        var appInfo = [String : Any]()
        appInfo["version"] = AppInfoConfig.appversion
        appInfo["deviceId"] = UUID().uuidString
        
        var deviceInfo = [String : Any]()
        deviceInfo["version"] = iOSVersion
//        deviceInfo["model"] = "\(device)"
                
        info["app"] = appInfo
        info["device"] = deviceInfo
        info["os"] = osInfo
        
        return info
    }
}
