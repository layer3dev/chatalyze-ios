//
//  SubmitRequestForNextEventNotification.swift
//  Chatalyze
//
//  Created by Mansa on 25/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubmitRequestForNextEventNotification{
    
    public func save(analystId:String,email:String, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/emailForEventNotification"
        
        var params = [String : Any]()
        
        params["email"] = email
        params["analystId"] = analystId
       
        
        Log.echo(key: "yud", text: "My sended Dict  new is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "response is\(response)")
        
        
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
