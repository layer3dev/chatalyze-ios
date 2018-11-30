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
    
    public func save(params:[String:Any], completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
     
        Log.echo(key: "yud", text: "Scheduled session dict is \(params)")
        
        Log.echo(key: "yud", text: "Url is  \(url)")        
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
           
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response in session request \(response)")
        
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
