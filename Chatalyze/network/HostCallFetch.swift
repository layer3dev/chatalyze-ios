//
//  HostCallFetch.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class HostCallFetch{
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : EventInfo?)->())){
        
       //dev.chatalyze.com/api/schedules/calls/all?include=callbookings&start=2018-03-29T00:00:00%2B05:30&userId=28
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/all"
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                completion(false, nil)
                return
        }
        guard let formattedDate = Date().removeTimeStamp()
            else{
                completion(false, nil)
                return
        }
        var params = [String : Any]()
        params["start"] = DateParser.dateToStringInServerFormat(formattedDate)
        params["userId"] = userId
        
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : EventInfo?)->())){
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        Log.echo(key: "yud", text: "Resonse of Fetch CAllSlots \(response)")
        
        guard let infos = response?.arrayValue
            else{
                completion(false, nil)
                return
        }
        
        if(infos.count <= 0){
            completion(false, nil)
            return
        }
        
        let info = infos[0]
        
        
        
        let eventInfo = EventInfo(info: info)
        
        Log.echo(key: "event", text: "event info --> \(String(describing: eventInfo.id))")
        
       
        
        completion(true, eventInfo)
        return
    }
}
