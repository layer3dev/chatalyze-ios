//
//  FetchAppVersionInfo.swift
//  Chatalyze
//
//  Created by Mansa on 10/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class FetchAppVersionInfo {
    
    public func fetchInfo(completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/appVersion"
        
        //https://dev.chatalyze.com/api/appVersion?plateform=iOS&deviceType=featured
        
        var params = [String : Any]()
        params["plateform"] = "iOS"
        params["deviceType"] = "featured"
        
        Log.echo(key: "yud", text:"url in the paymanet fetch is \(url)")
        
        ServerProcessor().request(.get, url, parameters : params, encoding: .queryString, authorize : false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response of Fetch payment is  \(response)")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let res = response
            else{
                completion(false, nil)
                return
        }
        
        completion(true, res)
        return
    }
}
