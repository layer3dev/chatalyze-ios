

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
        
        let device = Device()

        var info = [String : Any]()
        var deviceInfo = [String : Any]()
        deviceInfo["iOS"] = UIDevice.current.systemVersion
        deviceInfo["model"] = "\(device)"
        
        var appInfo = [String : Any]()
        appInfo["version"] = AppInfoConfig.appversion
        appInfo["deviceId"] = UUID().uuidString
        
        info["appInfo"] = appInfo
        info["deviceInfo"] = deviceInfo
        
        return info
    }
}
