//
//  CallBookingsFetch.swift
//  Chatalyze Autography
//
//  Created by Mansa on 31/10/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//


import Foundation
import SwiftyJSON

class CallBookingsFetch{
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : EventInfo?)->())){
        
        
        //https://chatitat.incamerasports.com/api/screenshots/?analystId=39&limit=5&offset=0
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/pagination"
      //  https://dev.chatalyze.com/api/bookings/calls/pagination?limit=4&offset=0&removePrevious=true&start=2018-03-22T00:00:00%2B05:30&userId=9
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                completion(false, nil)
                return
        }
        
        var params = [String : Any]()
        params["limit"] = 1
        params["offset"] = 0
        params["removePrevious"] = true
        params["start"] = DateParser.dateToStringInServerFormat(Date())
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
        
        Log.echo(key: "event", text: "event info --> \(eventInfo.id)")
        
        Log.echo(key: "event", text: "slot info --> \(eventInfo.callschedule?.id)")
        
        
//        guard let callBookingArray = response?.dictionary else{
//            return
//        }
        completion(true, eventInfo)
        return
    }
}
