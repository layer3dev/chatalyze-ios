//
//  submitContactUsRequest.swift
//  Chatalyze
//
//  Created by Mansa on 01/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

//
//  submitContactUsRequest.swift
//  Chatalyze
//
//  Created by Mansa on 12/09/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//
import Foundation
import SwiftyJSON

class submitContactUsRequest: NSObject {
    
    public func contactUs( email : String, message : String,name:String, completion : @escaping ((_ success : Bool)->())){
        let url = AppConnectionConfig.webServiceURL + "/contactUs/"
        
        var params = [String : Any]()
        params["email"] = email
        params["message"] = message
        params["name"] = name
        
        Log.echo(key: "yud", text: "Parameter are \(params)")
        Log.echo(key: "yud", text: "URl is \(url)")
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "yud", text: "Contact us submit Request is   \(response)")
        
        guard let rawInfo = response
            else{
                completion(false)
                return
        }
        
        if(!success){
            
            let message = rawInfo["message"].stringValue
            completion(false)
            return
        }
        
        completion(true)
        return
    }
}

