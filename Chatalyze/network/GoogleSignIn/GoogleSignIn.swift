//
//  GoogleSignIn.swift
//  Chatalyze
//
//  Created by Mansa on 20/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class GoogleSignIn{
    
    public func signin(accessToken : String?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        guard let accessToken = accessToken else {
            completion(false,"access Token is empty", nil)
            return
        }
        let url = AppConnectionConfig.webServiceURL + "/authenticate/oauth/google"
        
        var params = [String : Any]()
        params["code"] = accessToken
        params["clientId"] = "1084817921581-q7mnvrhvbsh3gkudbq52d47v2khle66s.apps.googleusercontent.com"
        params["redirectUrl"] = "https://dev.chatalyze.com"
        params["accessToken"] = accessToken
        params["roleId"] = LoginSignUpContainerController.roleId
        params["rememberMe"] = true
        
        if let deviceInfo = SessionDeviceInfo.sharedInstance{
            
            params["deviceId"] = deviceInfo.deviceId
            params["deviceToken"] = deviceInfo.deviceToken
            params["deviceType"] = AppInfoConfig.deviceType
            params["appType"] = AppInfoConfig.appType
        }
        
        Log.echo(key: "yud", text: "My sended Dict in Google param is \(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
          
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "yud", text: "Response from the Google Login is ==> \(response)")
        
        guard let rawInfo = response
            else{
                completion(false, "",  nil)
                return
        }
        
        if(!success){
            let message = rawInfo["message"].stringValue
            completion(false, message, nil)
            return
        }
        
        Log.echo(key: "token", text: "Parse user info now")
        
        let info = SignedUserInfo(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        info.save()
        completion(true, "", info)
        return
    }
}



