//
//  UploadHostCategory.swift
//  Chatalyze
//
//  Created by mansa infotech on 22/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class UploadHostCategory {
    
    public func upload(param:[String:Any],completion : @escaping ((_ success : Bool)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/tag/host"
        let params = param
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "yud", text: "Response from the upload category is  is \(String(describing: response))")
        
        completion(true)
        return
    }
}
