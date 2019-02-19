//
//  DonateCompleteTransaction.swift
//  Chatalyze
//
//  Created by Sumant Handa on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class DonateCompleteTransaction{
    
    public func process(transactionId : String, planId : String,  completion : @escaping ((_ success : Bool)->())){
        
        ///users/ +userId+ /tip/log/ios/confirmreceipt
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                completion(false)
                return
        }
        
        ///users/ +userId+ /tip/log/ios/create
        let url = AppConnectionConfig.webServiceURL + "/users/\(userId)/tip/log/ios/confirm"
        
        guard let receipt = createReceipt()
            else{
                completion(false)
                return
        }
        
 
        var params = [String : Any]()
        params["receipt"] = receipt
        params["planId"] = planId
        params["transactionId"] = transactionId
        
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "signininfo", text: "raw info ==>  \(response)" )
        
        //temp
        completion(true)
        return
    }
    
    private func createReceipt()->String?{
        let mainBundle = Bundle.main
        guard let receiptUrl = mainBundle.appStoreReceiptURL
            else{
                return nil
        }
        guard let isPresent = try? receiptUrl.checkResourceIsReachable()
            else{
                return nil
        }
        
        if(!isPresent){
            return nil
        }
        
        
        guard let receipt = NSData(contentsOf: receiptUrl)
            else{
                return nil
        }
        
        let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return receiptData
    }
}
