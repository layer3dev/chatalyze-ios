//
//  SubmitPaypalEmailProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubmitPaypalEmailProcessor{
    
    public func save(idOfEmail:String? = "",isEmailExists:Bool = true,analystId:String,email:String, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/paymentEmail/"
        url = (url)+(idOfEmail ?? "")

        var params = [String : Any]()
        
        params["email"] = email
        params["userId"] = analystId
                
        Log.echo(key: "yud", text: "My sended Dict  new is\(params)")
        
        if isEmailExists{
            
            
            Log.echo(key: "yud", text: "Yes email is existing \(isEmailExists)")
            ServerProcessor().request(.put, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
              
                self.handleResponse(withSuccess: success, response: response, completion: completion)
            }
        }else{
            
            Log.echo(key: "yud", text: "Yes email is not existing \(isEmailExists)")
            ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
               
                self.handleResponse(withSuccess: success, response: response, completion: completion)
            }
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response in saving the paypal email is \(String(describing: response))")

        guard let rawInfo = response
            else{
                completion(false, "Error occurred.",  nil)
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
