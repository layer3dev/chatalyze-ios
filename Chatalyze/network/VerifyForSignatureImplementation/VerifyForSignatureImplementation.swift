//
//  VerifyForSignatureImplementation.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 06/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class VerifyForSignatureImplementation {
    
    public func fetch(scheduleId:Int?, completion : @escaping ((_ success : Bool, _ error : String, _ response : BillingInfo?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/screenshots/schedule"
        guard let id = scheduleId else{
            completion(false, "Missing schedule id", nil)
            return
        }
        var param = [String:Any]()
        param["bookingId"] = id
        
        Log.echo(key: "yud", text: "url is \(url)")
        
        ServerProcessor().request(.get,url, parameters:param, encoding: .queryString, authorize :true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : BillingInfo?)->())) {
        
        Log.echo(key: "yud", text: "Fetched supported chats are  ==>  \(response)")
        
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
        let info = BillingInfo(info: rawInfo)
        //        {"pendingAmt":"13291.83","earnedAmt":"3677.58","tipAmt":"4.74","sponsorAmt":"0.00"}
        
        completion(true, "", info)
        return
    }
}
