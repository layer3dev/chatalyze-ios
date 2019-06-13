//
//  FetchBillingDetailProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class FetchBillingDetailProcessor {
    
    public func fetch( completion : @escaping ((_ success : Bool, _ error : String, _ response : BillingInfo?)->())){
        
        //https://dev.chatalyze.com/api36
        var url = AppConnectionConfig.webServiceURL + "/billinglogs/stats/"
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            completion(false, "Missing user id", nil)
            return
        }
        
        url = url+id
        
        Log.echo(key: "yud", text: "url is \(url)")
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding,authorize :true) { (success, response) in
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
