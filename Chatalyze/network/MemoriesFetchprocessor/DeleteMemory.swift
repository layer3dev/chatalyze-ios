//
//  DeleteMemory.swift
//  Chatalyze
//
//  Created by Mansa on 15/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class DeleteMemory{
    
    public func delete(id : String, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/screenshots"
        url = url+"/\(id)"
        
        let param:[String:Any] = [String:Any]()
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")
        
        ServerProcessor().request(.delete,url,parameters: param,encoding: .defaultEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Deleted memory is \(String(describing: response))")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response else{
            completion(false, nil)
            return
        }
        completion(true, rawInfo)
    }
}
