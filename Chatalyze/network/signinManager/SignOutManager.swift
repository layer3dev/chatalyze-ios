//
//  EmailSigninHandler.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON



class SignOutManager{
    
    public func signOut(completion : @escaping ((_ success : Bool)->())){
        
        UserDefaults.standard.removeObject(forKey: "SignatureImage")
        UserDefaults.standard.removeObject(forKey:"SignatureImageUrl")
        let url = AppConnectionConfig.webServiceURL + "/logout"
        var params = [String : Any]()
        
        if let deviceInfo = SessionDeviceInfo.sharedInstance{
            params["deviceId"] = deviceInfo.deviceId
            params["deviceType"] = AppInfoConfig.deviceType
        }
        guard let userInfo = SignedUserInfo.sharedInstance
            else{
                completion(false)
                return
        }
        
        params["userId"] = userInfo.id
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "token", text: "raw info ==>  \(response?.string)" )
        
        guard let rawInfo = response
            else{
                completion(false)
                return
        }
        if(!success){
            completion(false)
            return
        }
        completion(true)
        return
    }
}
