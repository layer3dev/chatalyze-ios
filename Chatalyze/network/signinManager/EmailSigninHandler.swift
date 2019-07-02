//
//  EmailSigninHandler.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON
import Bugsnag

class EmailSigninHandler{

    public func signin(withEmail email : String, password : String, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
       
        let url = AppConnectionConfig.webServiceURL + "/authenticate"
        
        var params = [String : Any]()
        params["email"] = email
        params["password"] = password
        params["rememberMe"] = true
        
        if let deviceInfo = SessionDeviceInfo.sharedInstance{
            
            params["deviceId"] = deviceInfo.deviceId
            params["deviceToken"] = deviceInfo.deviceToken
            params["deviceType"] = AppInfoConfig.deviceType
            params["appType"] = AppInfoConfig.appType
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "yud", text: "Response from the login is \(response)")
        
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
        
        
//        if let data = SignedUserInfo.sharedInstance{
//            data.fillInfo(info: rawInfo["user"])
//            let token = rawInfo["token"].stringValue
//            data.accessToken = token
//            data.save()
//            completion(true, "", data)
//            return
//        }
        
//        let info = SignedUserInfo(userInfoJSON: rawInfo["user"])
        
        
        let info = SignedUserInfo.initSharedInstance(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        
        Log.echo(key: "token", text: "token ==>  \(token)")
        info.save()
        
        
        //Bugsnag.notifyError(NSError(domain:"com.customCrash:SignIn", code:408, userInfo:nil))
        
        completion(true, "", info)
        return
    }
}
