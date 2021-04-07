//
//  CustomTicketsHandler.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class CustomTicketsHandler: NSObject {
    
    func fetchInfo(with id:String, offset:Int, completion: @escaping ((_ success : Bool , _ response: [CustomTicketsInfo]?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/users/" + id + "/claimlist"
        var param : [String: Any] = [String: Any]()
        param["limit"] = 2
        param["offset"] = offset
        
        ServerProcessor().request(.get, url, parameters: param, encoding: .customGETEncoding, authorize: true) { (success, response) in
            self.handleResponse(with: success, response: response!, completion: completion)
        }
        
    }
    
    
    func handleResponse(with success:Bool,response: JSON? , completion: @escaping ((_ success : Bool , _ response: [CustomTicketsInfo]?)->())){
        
        
        Log.echo(key: "CustomTicketsHandler", text: "Resonse of Fetch Info :\(String(describing: response))")
        
        if !success{
            completion(false,nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
        var memoryInfoArray:[CustomTicketsInfo] = [CustomTicketsInfo]()
        if rawInfo.count <= 0 {
            completion(true, memoryInfoArray)
            return
        }
        for info in rawInfo{
            let obj = CustomTicketsInfo(info: info)
            memoryInfoArray.append(obj)
        }
        completion(true, memoryInfoArray)
        return

    }
}
