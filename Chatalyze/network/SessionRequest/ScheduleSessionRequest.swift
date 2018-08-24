//
//  ScheduleSessionRequest.swift
//  Chatalyze
//
//  Created by Mansa on 24/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduleSessionRequest{
    
    //https://dev.chatalyze.com/api/users/50
    public func save(params:[String:Any], completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
     
        Log.echo(key: "yud", text: "My sended Dict  new is\(params)")
        
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
            completion(false, message, response)
            return
        }
        completion(true, "", response)
        return
    }
}
