//
//  CallEventInfo.swift
//  Chatalyze Autography
//
//  Created by Mansa on 31/10/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//


import Foundation
import SwiftyJSON

class CallEventInfo{
    
    public func fetchInfo(eventId : String, completion : @escaping ((_ success : Bool, _ response : EventScheduleInfo?)->())){
        
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/\(eventId)"
        Log.echo(key: "vijayAPI", text: url)
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : EventScheduleInfo?)->())){
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
                
        let eventInfo = EventScheduleInfo(info: info)
        
        Log.echo(key: "event", text: "event info --> \(String(describing: eventInfo.id))")
        
        completion(true, eventInfo)
        return
    }
}

