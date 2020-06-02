//
//  RefreshDeviceToken.swift
//  Chatalyze
//
//  Created by Mansa on 04/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class RefreshDeviceToken{
    
    public func update( completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/refresh"
        
        var params = [String : Any]()
               
        if let deviceInfo = SessionDeviceInfo.sharedInstance{
            
            params["deviceId"] = deviceInfo.deviceId
            params["deviceToken"] = deviceInfo.deviceToken
            params["deviceType"] = AppInfoConfig.deviceType
            params["appType"] = AppInfoConfig.appType
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding , authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response from the refreshToken is \(response)")
        
        if !success{
            completion(false, "error",  nil)
        }
        
        guard let rawInfo = response
            else{
                completion(false, "error",  nil)
                return
        }
        completion(true, "", rawInfo)
        return
    }
}
