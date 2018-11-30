//
//  ActivateEvent.swift
//  Chatalyze
//
//  Created by Sumant Handa on 06/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class ActivateEvent{
    
    public func activate(eventId : String, completion : @escaping ((_ success : Bool, _ response : EventScheduleInfo?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/\(eventId)"
        
        var params = [String : Any]()
        params["started"] = DateParser.dateToStringInServerFormat(Date())
        
        
        ServerProcessor().request(.put, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : EventScheduleInfo?)->())){
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        Log.echo(key: "response", text: "Resonse of Fetch CAllSlots \(response)")
        
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
