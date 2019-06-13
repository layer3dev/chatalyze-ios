//
//  FetchAnalystPaymentHistory.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchAnalystPaymentHistory {
    
    public func fetch(limit:Int,offset:Int,completion : @escaping ((_ success : Bool, _ error : String, _ response : [AnalystPaymentInfo]?)->())){
        
        var params:[String:Any] = [String:Any]()
        //https://dev.chatalyze.com/api/billinglogs/user/36?limit=5&offset=0
        
        var url = AppConnectionConfig.webServiceURL + "/billinglogs/user/"
        guard let id = SignedUserInfo.sharedInstance?.id else{
            completion(false, "Missing user id", nil)
            return
        }
        url = url+id
        params["limit"] = limit
        params["offset"] = offset
                
        Log.echo(key: "yud", text: "url is \(url)")
        
        ServerProcessor().request(.get, url,parameters: params, encoding: .queryString,authorize :true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : [AnalystPaymentInfo]?)->())) {
        
        Log.echo(key: "yud", text: "Fetched analyst payment history are  ==>  \(response)")
        
        guard let rawInfo = response
            else{
                completion(false, "",  nil)
                return
        }
        
        if(!success){
            
            let message = "some error occurred"
            completion(false, message, nil)
            return
        }
        
        let arrayOfJson = rawInfo.arrayValue
        var infoArray = [AnalystPaymentInfo]()
        
        for info in arrayOfJson{
            let info = AnalystPaymentInfo(info: info)
            infoArray.append(info)
        }
        
        completion(true, "", infoArray)
        return
    }
}
