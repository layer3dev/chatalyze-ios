//
//  EmailResetPasswordRequest.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 27/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON


class EmailResetPasswordRequest{
    
    public func resetRequest(withEmail email : String, completion : @escaping ((_ success : Bool, _ error : String)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/forgot/send"
        
        var params = [String : Any]()
        params["email"] = email
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String)->())){
        
        Log.echo(key: "signininfo", text: "raw info ==>  \(response)" )
        
        guard let rawInfo = response
            else{
                completion(false, "")
                return
        }        
        if(!success){
            let message = rawInfo["message"].stringValue
            completion(false, message)
            return
        }
        //let success
        completion(true, "")
        return
    }
}

