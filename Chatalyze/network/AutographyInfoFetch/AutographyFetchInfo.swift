//
//  AutographyFetchInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 17/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AutographyFetchInfo{
    
    public func fetchInfo(id : String, completion : @escaping ((_ success : Bool, _ response : AutographInfo?)->())){
        
        //https://chatitat.incamerasports.com/api/screenshots/?analystId=39&limit=5&offset=0
        var url = AppConnectionConfig.webServiceURL + "/screenshots"
        url += "/" + id
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : AutographInfo?)->())){
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        let info = AutographInfo(info: response)
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page \(response)")
        completion(true, info)
        return
    }
}
