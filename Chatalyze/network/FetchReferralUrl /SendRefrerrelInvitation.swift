//
//  SendRefrerrelInvitation.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SendRefrerrelInvitation {
    
    public func send(param:[String:Any],completion : @escaping ((_ success : Bool,_ response:JSON?)->())){
     //   https://dev.chatalyze.com/api
        let url = AppConnectionConfig.webServiceURL + "/registerlink/email/share"
        
        let params = param
        Log.echo(key: "yud", text: "My sended Dict is \(params) and the url is \(url)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool,_ response:JSON?)->())){
        
        Log.echo(key: "yud", text: "Response from the upload category is  is \(String(describing: response))")
        
        if success{
            completion(true,response)
            return
        }
        completion(false,response)
        return
    }
}

