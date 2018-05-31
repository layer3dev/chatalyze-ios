//
//  FetchSavedCardDetails.swift
//  Chatalyze
//
//  Created by Mansa on 31/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchSavedCardDetails{
    
    public func fetchInfo(id : String, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/cards/"
        var param:[String:Any] = [String:Any]()
        //param["id"] = id
        url += id
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")
        
        
        ServerProcessor().request(.get,url,parameters: param,encoding: .queryString, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
        Log.echo(key: "yud", text: "Value of the success is \(String(describing: response?.description))")
        
        if(!success){
            completion(false, nil)
            return
        }
        completion(true, response)
        return
    }
    
    
}

