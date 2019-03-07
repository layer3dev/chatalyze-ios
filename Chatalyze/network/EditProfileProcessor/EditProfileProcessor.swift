//
//  EditProfileProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class EditProfileProcessor{
    
    public func edit(params:[String:Any], completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        if let id = SignedUserInfo.sharedInstance?.id{
            url = url+"\(id)"
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params) and the url is \(url)")
        
        ServerProcessor().request(.put, url, parameters: params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response in the Edit Profile  \(response)")
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
        completion(true, "", nil)
        return
    }
}
