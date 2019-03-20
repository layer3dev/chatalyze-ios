//
//  GetPlanRequestProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class GetPlanRequestProcessor{
    
    public func fetch( completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            completion(false,"Anlayst id is missing.", nil)
            return
        }
        url = url+id
        url = url+"/analysts/plan"
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding,authorize :false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Fetched plans are  ==>  \(response)")
        
        Log.echo(key: "yud", text: "Email Signin ==>  \(success)")
        
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
        
        completion(true, "", rawInfo)
        return
    }
}
