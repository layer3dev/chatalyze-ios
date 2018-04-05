//
//  SubmitScreenshot.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class SubmitScreenshot{
    
    public func submitScreenshot(params : [String : Any], completion : @escaping ((_ success : Bool, _ response : EventScheduleInfo?)->())){
        

        let url = AppConnectionConfig.webServiceURL + "/screenshots"
        
        
        ServerProcessor().request(.post, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
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

