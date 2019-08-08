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
    
    public func fetch(scheduleId:Int?, completion : @escaping ((_ success : Bool, _ error : String, _ isSigned : Bool,_ isRequested:Bool)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/screenshots/schedule"
        
        guard let id = scheduleId else{
            completion(false, "Missing schedule id", false,false)
            return
        }
        var param = [String:Any]()
        param["bookingId"] = id
        
        Log.echo(key: "yudi", text: "VerifyForSignatureImplementation is \(url) and the params are \(param)")
        
        ServerProcessor().request(.get,url, parameters:param, encoding: .queryString, authorize :true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ isSigned : Bool,_ isRequested:Bool)->())) {
        
        Log.echo(key: "yudi", text: " VerifyForSignatureImplementation supported chats are  ==>  \(String(describing: response))")
        
        guard let rawInfo = response
            else{
                completion(false, "",  false, false)
                return
        }
        
        if(!success){
            
            let message = "some error occurred"
            completion(false, message, false, false)
            return
        }
        
        let arrayValue = rawInfo.arrayValue
        var isSigned = false
        var isRequested = false
        
        for info in arrayValue{
            
            if info["signed"].boolValue{
            
                isSigned = true
            }
            if info["requestedAutograph"].boolValue{
                
                isRequested = true
            }
        }
        completion(true, "", isSigned,isRequested)
        return
    }
}
