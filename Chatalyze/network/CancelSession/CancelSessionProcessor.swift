//
//  CancelSessionProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class CancelSessionProcessor{
    
    public func cancel(id:String,completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
       // https://dev.chatalyze.com/api/schedules/calls/6842
        var url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        url = url+id
        
        Log.echo(key: "yud", text:"url in the cancel Event is  fetch is \(url)")
       var  params = [String:Any]()
        
        ServerProcessor().request(.delete, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
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
