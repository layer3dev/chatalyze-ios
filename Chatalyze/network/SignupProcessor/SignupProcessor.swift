//
//  SignupProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 02/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class SignupProcessor{
    
    public func signup(withEmail email : String, password : String,name:String, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/users"
        
        var params = [String : Any]()
        params["email"] = email
        params["password"] = password
        params["token"] = false
        params["roleId"] = LoginSignUpContainerController.roleId
        params["firstName"] = name
        
        if LoginSignUpContainerController.roleId == 0{
            completion(false, "invalid role Id",  nil)
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Raw Email Signin Handler info ==>  \(String(describing: response))")
        
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
        
        let info = SignedUserInfo(userInfoJSON: rawInfo["user"])
        if let id = info.id {
            Log.echo(key: "yud", text: "Alias is calling")
            SEGAnalytics.shared().alias(id)
        }
        completion(true, "", nil)
        return
    }
}
