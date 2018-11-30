//
//  ProvisiningProfileStatus.swift
//  Chatalyze
//
//  Created by Mansa on 03/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
class ProvisiningProfileStatus {
    
    static func isDevelopmentProvisioningProfile() -> Bool {
        #if IOS_SIMULATOR
        return true
        #else
        // there will be no provisioning profile in AppStore Apps
        guard let fileName = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") else {
            return false
        }
        
        let fileURL = URL(fileURLWithPath: fileName)
        // the documentation says this file is in UTF-8, but that failed
        // on my machine. ASCII encoding worked ¯\_(ツ)_/¯
        guard let data = try? String(contentsOf: fileURL, encoding: .ascii) else {
            return false
        }
        
        let cleared: String = data.components(separatedBy: .whitespacesAndNewlines).joined()
        return cleared.contains("<key>get-task-allow</key><true/>")
        #endif
    }
}
