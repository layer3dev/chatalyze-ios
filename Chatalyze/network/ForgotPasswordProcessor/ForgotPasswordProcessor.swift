//
//  ForgotPasswordProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 03/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForgotPasswordProcessor{
    
    public func sendPassword(withEmail email : String, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/forgot/send"
        
        var params = [String : Any]()
        params["email"] = email
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "raw Email Signin Handler info ==>  \(response)")
        
        Log.echo(key: "token", text: "Email Signin ==>  \(success)")
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
