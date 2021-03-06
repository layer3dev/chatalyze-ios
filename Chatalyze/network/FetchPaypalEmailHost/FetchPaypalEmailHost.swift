//
//  FetchPaypalEmailHost.swift
//  Chatalyze
//
//  Created by Mansa on 31/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchPaypalEmailHost{
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        
        var url = AppConnectionConfig.webServiceURL + "/paymentEmail/user/"
        
        guard let userId = SignedUserInfo.sharedInstance?.id
            else{
                completion(false, nil)
                return
        }
        url = url+userId
        var params = [String : Any]()
        
        Log.echo(key: "yud", text:"url in the paymanet fetch is \(url)")
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch payment is  \(response) ands the success  is \(success)")
        
        if(!success){
            completion(false, nil)
            return
        }        
        completion(true, response)
        return
    }
}
