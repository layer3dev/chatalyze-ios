//
//  PurchaseTicketManager.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 12/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class PurchaseTicketManager: NSObject {
    
    func fethcInfo (userId : String , sessionId: String , date: String, completionHandler : @escaping (_ success : Bool, _ response:JSON?)->Void){
        
        
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/purchaseTicket/"
        
        var param : [String:Any] = [String:Any]()
        param["userId"] = userId
        param["callscheduleId"] = sessionId
        param["browserDate"] = date
        param["claimType"] = true
        
        
        Log.echo(key: "PurchaseTicket", text: "API Request is : -\(param)")
        
        ServerProcessor().request(.post, url, parameters: param, encoding: .defaultEncoding, authorize: true) { (success, response) in
            
            self.handleResponse(success: success, response: response, completionHandler: completionHandler)
        }
        
    }
    
    private func handleResponse(success : Bool, response: JSON?,completionHandler : @escaping (_ success : Bool, _ response:JSON?)->Void){
        
        Log.echo(key: "PurchaseTicketManager", text: "Responsw from PurchaseTicketManager is :\(response)")
        
        if !success{
            completionHandler(false,nil)
        }
        
        
        guard let rawInfo = response else {
            completionHandler(false,nil)
            return
        }
        
       completionHandler(true,rawInfo)
        
    }
}
