//
//  SessionRequestWithImageProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SessionRequestWithImageProcessor{
    
    public func schedule(params : [String : Any], completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        
        Log.echo(key: "yud", text: "PARAMS ARE \(params)")
        
        ServerProcessor().request(.post, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "imageUploading", text: "Response from the server is  \(response)")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
        
        completion(true, info)
        return
    }
}
