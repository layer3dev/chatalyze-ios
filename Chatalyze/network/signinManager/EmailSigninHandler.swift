//
//  EmailSigninHandler.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON

class EmailSigninHandler{

    public func signin(withEmail email : String, password : String, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
       
        let url = AppConnectionConfig.webServiceURL + "/authenticate"
        
        var params = [String : Any]()
        params["email"] = email
        params["password"] = password
        
        if let deviceInfo = SessionDeviceInfo.sharedInstance{
            
            params["deviceId"] = deviceInfo.deviceId
            params["deviceToken"] = deviceInfo.deviceToken
            params["deviceType"] = AppInfoConfig.deviceType
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "token", text: "raw Email Signin Handler info ==>  \(response)")
        
        Log.echo(key: "token", text: "Email Signin ==>  \(success)")
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
        
        Log.echo(key: "token", text: "parse user info now")
        
        let info = SignedUserInfo(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        
        Log.echo(key: "token", text: "token ==>  \(token)")
        info.save()
        completion(true, "", info)
        return
    }
}
