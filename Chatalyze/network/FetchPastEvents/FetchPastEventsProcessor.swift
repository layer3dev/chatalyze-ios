//
//  FetchPastEventsProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 02/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchPastEventsProcessor{
    
    public func fetch(offset:Int, completion : @escaping ((_ success : Bool, _ error : String, _ response : [EventInfo]?)->())){
        
        //https://dev.chatalyze.com/api/schedules/calls/pastEventAnalyst?limit=5&offset=0&order=start&order=desc&past=true&userId=36
        
        var url = AppConnectionConfig.webServiceURL + "/schedules/calls/pastEventAnalyst"
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            completion(false,"Anlayst id is missing.", nil)
            return
        }
        
        var param = [String:Any]()
        param["limit"] = 8
        param["offset"] = offset
        param["order"] = ["start","desc"]
        param["past"] = true
        param["userId"] = 36
        
        Log.echo(key: "yud", text: "params are \(param)")
        
        ServerProcessor().request(.get, url,parameters: param, encoding: .queryString,authorize :false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : [EventInfo]?)->())){
        
        Log.echo(key: "yud", text: "past events are ==>  \(response)")

        
        if(!success){
            completion(false,"",nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false,"",nil)
            return
        }
        var eventArray:[EventInfo] = [EventInfo]()
        if rawInfo.count <= 0 {
            completion(true,"",eventArray)
            return
        }
        for info in rawInfo{
            let obj = EventInfo(info: info)
            eventArray.append(obj)
        }
        completion(true, "Fetched the past events successfully.", eventArray)
        return
    }
}
