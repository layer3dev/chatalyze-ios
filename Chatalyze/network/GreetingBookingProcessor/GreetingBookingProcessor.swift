//
//  GreetingBookingProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 15/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class GreetingBookingProcessor{
    
    public func fetchInfo(param : [String:Any], completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/greetings/"
        
        ServerProcessor().request(.post,url,parameters: param,encoding: .jsonEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
        Log.echo(key: "yud", text: "Value of the success is \(response?.description)")
        
        guard let rawInfo = response
            else{
                completion(false,nil)
                return
        }
        if(!success){
            completion(false, nil)
            return
        }        
        completion(true, rawInfo)
        return
    }
}

