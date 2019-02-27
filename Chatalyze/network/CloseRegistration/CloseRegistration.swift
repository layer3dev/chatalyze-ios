//
//  CloseRegistration.swift
//  Chatalyze
//
//  Created by mansa infotech on 27/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class CloseRegistration {
    
    public func close(eventId:String,completion : @escaping ((_ success : Bool)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/schedules/calls"
        url = url + "/\(eventId)"
        let params = [String:Any]()
        Log.echo(key: "yud", text: "My sended Dict is \(params) and the url is \(url)")
        
        ServerProcessor().request(.patch, url, parameters: params, encoding: .jsonEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool)->())){
        
        Log.echo(key: "yud", text: "Response from the upload category is  is \(String(describing: response))")
        
        if success{
            completion(true)
            return
        }
        completion(false)
        return
    }
}

