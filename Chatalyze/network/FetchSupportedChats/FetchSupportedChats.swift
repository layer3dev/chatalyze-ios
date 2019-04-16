//
//  FetchSupportedChats.swift
//  Chatalyze
//
//  Created by mansa infotech on 16/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class FetchSupportedChats {
    
    public func fetch( completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/supportedChats"
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding,authorize :false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())) {
        
        Log.echo(key: "yud", text: "Fetched supported chats are  ==>  \(response)")
        
        
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
        
        completion(true, "", rawInfo)
        return
    }
}

