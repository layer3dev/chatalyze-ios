//
//  CallSlotFetch.swift
//  Chatalyze Autography
//
//  Created by Mansa on 31/10/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//
import Foundation
import SwiftyJSON


class CallSlotFetch{
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : EventSlotInfo?)->())){
        fetchInfos { (success, slotInfos) in
            if(!success){
                completion(false, nil)
                return
            }
            
            guard let infos = slotInfos
                else{
                    completion(false, nil)
                    return
            }
            
            if(infos.count == 0){
                completion(false, nil)
                return
            }
            
            completion(true, infos[0])
            return
        }
    }
    
    
    
    public func fetchInfos(completion : @escaping ((_ success : Bool, _ response : [EventSlotInfo]?)->())){
        
        
        //https://chatitat.incamerasports.com/api/screenshots/?analystId=39&limit=5&offset=0
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/pagination"
        //  https://dev.chatalyze.com/api/bookings/calls/pagination?limit=4&offset=0&removePrevious=true&start=2018-03-22T00:00:00%2B05:30&userId=9
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
        params["limit"] = 100
        params["offset"] = 0
        params["removePrevious"] = true
        params["start"] = DateParser.dateToStringInServerFormat(formattedDate)
        params["userId"] = userId
        
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [EventSlotInfo]?)->())){
        
        
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
        var slotInfos = [EventSlotInfo]()
        
        for rawInfo in infos {
            let eventInfo = EventSlotInfo(info: rawInfo)
            slotInfos.append(eventInfo)
        }
        
        
        
        
        
        completion(true, slotInfos)
        return
    }
}
