//
//  FetchProfileProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 16/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchProfileProcessor{
    
    public func fetch( completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        url = url+id
        
        var params = [String : Any]()
        
        
        Log.echo(key: "yud", text: "My sended Dict is\(params)")
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding,authorize :false) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "getting fetch profileInfo  ==>  \(response)")
        
        Log.echo(key: "yud", text: "Email Signin ==>  \(success)")
        guard let rawInfo = response
            else{
                completion(false, "",  nil)
                return
        }
        
        if(!success){
            let message = rawInfo["message"].stringValue
            completion(false, message, nil)
            return
        }
        
        
        guard let profileInfo = SignedUserInfo.sharedInstance else {
            let message = rawInfo["message"].stringValue
            completion(false, message, nil)
            return
        }
        
        profileInfo.fillInfo(info: rawInfo)
         RootControllerManager().getCurrentController()?.menuController?.updateMenuInfo()
        
        completion(true, "", rawInfo)
        return
    }
}
