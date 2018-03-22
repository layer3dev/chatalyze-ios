
//
//  FacebookLogin.swift
//  Chatalyze
//
//  Created by Sumant Handa on 28/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import FacebookCore


class FacebookLogin{
    
    /*
     NSMutableDictionary *parameter = [NSMutableDictionary new];
     parameter[@"access_token"] = [accessToken tokenString];
     parameter[@"token_type"] = @"Bearer";
     parameter[@"expires_in"] = [NSString stringWithFormat:@"%d", (int)[[accessToken expirationDate] timeIntervalSinceNow]];
     
     NSMutableDictionary *parameterInfo = [NSMutableDictionary new];
     parameterInfo[@"accessToken"] = parameter;
     */
    
    public func signin(accessToken : FacebookCore.AccessToken?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        guard let accessToken = accessToken
            else{
                completion(false, "Access Denied !", nil)
                return
        }
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/oauth/facebook"
        /*params["clientId"] = "1617857558307283"
         params["code"] = accessToken
         params["redirectUri"] = AppConnectionConfig.webServiceURL + "/"*/
        
        var params = [String : Any]()
        
        var rawParam = [String : String]()
        rawParam["access_token"] = accessToken.authenticationToken
        rawParam["token_type"] = "Bearer"
        rawParam["expires_in"] = String(accessToken.expirationDate.timeIntervalSinceNow)
        
        params["accessToken"] = rawParam
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "token", text: "raw info ==>  \(response)")
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
        
        let info = SignedUserInfo(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        completion(true, "", info)
        return
    }
}

