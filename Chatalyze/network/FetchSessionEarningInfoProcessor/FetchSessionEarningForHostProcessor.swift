//
//  FetchSessionEarningForHostProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class FetchSessionEarningForHostProcessor {
    
    public func fetchInfo(sessionId:String,completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        var  url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        
        url = url + "\(sessionId)"
        url = url + "/moneyStats"
    
        var params = [String:Any]()
        
        Log.echo(key: "yud", text:"url in the paymanet fetch is \(url)")
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch payment is  \(response)")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let res = response
            else{
                completion(false, nil)
                return
        }
        
        completion(true, res)
        return
    }
}
