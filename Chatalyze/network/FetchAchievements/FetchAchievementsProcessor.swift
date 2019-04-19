//
//  FetchAchievementsProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchAchievementsProcessor {
    
    public func fetch( completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        guard let userId = SignedUserInfo.sharedInstance?.id else{
            completion(false,"User id is missing.",nil)
            return
        }//https://dev.chatalyze.com/api/users/50/achievement
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        url = url+userId
        url = url+"/achievement"
        
        Log.echo(key: "yud", text: "achievement url is \(url)")
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding,authorize :false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())) {
        
        Log.echo(key: "yud", text: "Fetched FetchAchievementsProcessor  are  ==>  \(response)")
        
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


