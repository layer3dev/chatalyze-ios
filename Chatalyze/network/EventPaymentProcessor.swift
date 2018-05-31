//
//  EventPaymentProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 30/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventPaymentProcessor{
    
    public func pay(param:[String:Any], completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/purchaseTicket/"
        let newdate = DateParser.getCurrentDateTimeInStringWithWebFormat(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ssXXX")
        var params = param
        params["browserDate"] = newdate
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params,encoding: .jsonEncoding, authorize :true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
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
        completion(true, "", nil)
        return
    }
}
