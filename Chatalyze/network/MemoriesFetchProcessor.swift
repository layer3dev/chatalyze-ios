
//
//  MemoriesFetchProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 19/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

//https://dev.chatalyze.com/api/screenshots/?limit=4&offset=12&order=updatedAt&order=DESC&userId=50

class MemoriesFetchProcessor{
    
    public func fetchInfo(id : String,offset:Int?, completion : @escaping ((_ success : Bool, _ response : [MemoriesInfo]?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/screenshots"
        
        var param:[String:Any] = [String:Any]()
        param["limit"] = 10
        param["offset"] = offset ?? 0
        param["userId"] = id
        param["order"] = ["updatedAt","DESC"]
        
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")
        
        ServerProcessor().request(.get,url,parameters: param,encoding: .customGETEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [MemoriesInfo]?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
        
        Log.echo(key: "yud", text: "Value of the success is \(response?.description)")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
        var memoryInfoArray:[MemoriesInfo] = [MemoriesInfo]()
        if rawInfo.count <= 0 {
            completion(true, memoryInfoArray)
            return
        }
        for info in rawInfo{
            let obj = MemoriesInfo(info: info)
            memoryInfoArray.append(obj)
        }
        completion(true, memoryInfoArray)
        return
    }
    
    
}

