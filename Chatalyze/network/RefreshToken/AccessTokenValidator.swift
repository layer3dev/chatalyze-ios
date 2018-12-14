//
//  AccessTokenValidator.swift
//  Chatalyze
//
//  Created by Mansa on 10/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccessTokenValidator {

    public func validate(completion : @escaping ((_ success : Bool)->())){
      
        //https://www.chatalyze.com/api/authenticate/refresh
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/refresh"
        
        var params = [String : Any]()
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "yud", text: "Response from the login is \(String(describing: response))")
        
        guard let rawInfo = response
            else{
                completion(true)
                return
        }
        
        Log.echo(key: "yud", text: "I am verifying the token \(rawInfo["success"])")
        
        let successResult = rawInfo["success"].boolValue
        completion(successResult)
        return
    }
}
