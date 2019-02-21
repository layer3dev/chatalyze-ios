//
//  DonateCreateTransaction.swift
//  Chatalyze
//
//  Created by Sumant Handa on 18/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class DonateCreateTransaction{
    
    func createTransaction(value : DonateProductInfo.value, sessionId : Int, slotId : Int, completion: @escaping (_ success: Bool, _ transactionId : String?) -> ()) {
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                completion(false, nil)
                return
        }
        
        ///users/ +userId+ /tip/log/ios/create
        let url = AppConnectionConfig.webServiceURL + "/users/\(userId)/tip/log/ios/create"
        
        var params = [String : Any]()
        params["planId"] = value.getProductId()
        params["chatId"] = slotId
        params["callscheduleId"] = sessionId
        
        Log.echo(key: "in_app_purchase", text: "create transaction -> \(params.JSONDescription())")
        
        
        ServerProcessor().request(.post, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ transactionId : String?)->())){
        
        Log.echo(key: "in_app_purchase", text: "create transaction handleResponse-> \(response)")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
        
        let transactionId = info["transactionId"].stringValue
    
        
        completion(true, transactionId)
        return
    }
}

