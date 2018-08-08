//
//  DeactivateAccountProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeactivateAccountProcessor{
    
    public func deactivate(completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        if let id = SignedUserInfo.sharedInstance?.id{
            url = url+"\(id)"+"/deactivate"
        }else{
            completion(false, "",  nil)
            return
        }
        print("The url is")
        print(url)
        var params = [String:Any]()
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        if(!success){
            
            completion(false, "", nil)
            return
        }
        completion(true, "", nil)
        return
    }
}
