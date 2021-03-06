//
//  PaymentHistoryProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class PaymentHistoryProcessor{
    
    public func fetchInfo(id : String,offset:Int?, completion : @escaping ((_ success : Bool, _ response : [PaymentListingInfo]?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/billinglogs/user/"
                
        var param:[String:Any] = [String:Any]()        
        url = url+id
        param["limit"] = 1
        param["offset"] = offset ?? 0
      
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")
        
        ServerProcessor().request(.get,url,parameters: param,encoding: .queryString, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [PaymentListingInfo]?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
        Log.echo(key: "yud", text: "Value of the success is \(response?.description)")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
        var paymentInfoArray:[PaymentListingInfo] = [PaymentListingInfo]()
        if rawInfo.count <= 0 {
            completion(true, paymentInfoArray)
            return
        }
        for info in rawInfo{
            let obj = PaymentListingInfo(info: info)
            paymentInfoArray.append(obj)
        }
        completion(true, paymentInfoArray)
        return
    }
    
    
}

