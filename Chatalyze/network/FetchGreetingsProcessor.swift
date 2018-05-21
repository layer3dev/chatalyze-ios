//
//  FetchGreetingsProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

//https://dev.chatalyze.com/api/greetingControl/availableAnalysts/?fetchTestAnalysts=false&limit=6&offset=0&order=id&order=ASC

class FetchGreetingsProcessor{
    
    public func fetchInfo(id : String,offset:Int?, completion : @escaping ((_ success : Bool, _ response : [GreetingInfo]?)->())){
        
        
        let url = AppConnectionConfig.webServiceURL + "/greetingControl/availableAnalysts/"
        
        var param:[String:Any] = [String:Any]()
        
        param["fetchTestAnalysts"] = false
        param["limit"] = 1
        param["offset"] = offset ?? 0
        param["order"] = ["id","ASC"]
        
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")
        
        ServerProcessor().request(.get,url,parameters: param,encoding: .customGETEncoding, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [GreetingInfo]?)->())){
        
        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
        Log.echo(key: "yud", text: "Value of the success is \(String(describing: response?.description))")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
        var greetingArray:[GreetingInfo] = [GreetingInfo]()
        if rawInfo.count <= 0 {
            completion(true, greetingArray)
            return
        }
        for info in rawInfo{
            let obj = GreetingInfo(info: info)
            greetingArray.append(obj)
        }
        completion(true, greetingArray)
        return
    }
    
    
}

