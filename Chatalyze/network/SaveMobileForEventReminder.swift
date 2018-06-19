//
//  SaveMobileForEventReminder.swift
//  Chatalyze
//
//  Created by Mansa on 04/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SaveMobileForEventReminder{
    
    //https://dev.chatalyze.com/api/users/50
    public func save(mobilenumber : String, countryCode:String,saveForFuture : Bool, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            completion(false, "",  nil)
            return
        }
        
        url = url+id
        
        var params = [String : Any]()
        
      //params["eventMobReminder"] = saveForFuture
      //params["countryCode"] = countryCode
      //params["mobile"] = mobilenumber
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.put, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "raw Email Signin Handler info ==>  \(response)")
        
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
        completion(true, "", nil)
        return
    }
}
