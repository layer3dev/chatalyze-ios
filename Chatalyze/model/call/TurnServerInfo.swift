//
//  TurnServerInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 10/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TurnServerInfo: NSObject {
    
    @objc static let sharedInstance = TurnServerInfo()
    @objc var infos = [RTCIceServer]()
    
    func fillInfos(infos : [JSON]){
        var configInfos = [RTCIceServer]()
        for info in infos {
            guard let configInfo = self.instance(info: info)
                else{
                    continue
            }
            configInfos.append(configInfo)
        }
        
        self.infos = configInfos
    }
    
    private func instance(info : JSON)->RTCIceServer?{
        
        guard let url = info["url"].string
            else{
                return nil
        }
        
        let username = info["username"].stringValue
        let credential = info["credential"].stringValue
        
        let config = RTCIceServer(urlStrings: [url], username: username, credential: credential)
        return config
        
    }
}
