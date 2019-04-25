//
//  FetchOldTicketsProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchOldTicketsProcessor{
    
    var offset = 0
    
    public func fetchInfo(offset:Int, limit: Int,completion : @escaping ((_ success : Bool, _ response : EventSlotInfo?)->())){
        
        self.offset = offset
        
        fetchInfos(offset: offset, limit: limit) { (success, slotInfos) in
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
    
    public func fetchInfos(offset:Int,limit:Int,completion : @escaping ((_ success : Bool, _ response : [EventSlotInfo]?)->())){
        
        //https://chatitat.incamerasports.com/api/screenshots/?analystId=39&limit=5&offset=0
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/pagination"
        
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
        params["limit"] = limit
        params["offset"] = offset
        //params["removePrevious"] = false
        params["end"] = DateParser.dateToStringInServerFormat(Date())
        params["userId"] = userId
        params["order"] = ["end","desc"]        
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [EventSlotInfo]?)->())) {
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let infos = response?.arrayValue
            else{
                completion(false, nil)
                return
        }
        
        if(infos.count <= 0){
            completion(success, nil)
            return
        }
        
        var slotInfos = [EventSlotInfo]()
        
        for rawInfo in infos {
            
            let eventInfo = EventSlotInfo(info: rawInfo)
            if eventInfo.slotNo == nil || eventInfo.slotNo == 0{
            }else{
                slotInfos.append(eventInfo)
            }
        }
        completion(true, slotInfos)
        return
    }
}

