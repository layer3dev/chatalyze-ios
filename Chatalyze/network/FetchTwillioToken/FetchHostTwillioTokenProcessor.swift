//
//  FetchHostTwillioTokenProcessor.swift
//  Chatalyze
//
//  Created by Yudhisther on 17/08/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchHostTwillioTokenProcessor {
    
    public func fetch(sessionId:String?,chatID:Int?,greenRoom:Bool?, completion : @escaping ((_ success : Bool, _ error : String,_ info:TwillioTokenInfo?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/schedules/token"
        
        guard let id = sessionId else{
            completion(false, "Missing chat id",nil)
            return
        }
    
        guard let chatid = chatID else{
                  completion(false, "Missing chat id",nil)
                  return
              }
        var param = [String:Any]()
        param["sessionId"] = id
        param["chatId"] = chatid
        if let green = greenRoom {
            param["greenRoom"] = green
        }
        
        Log.echo(key: "twillio", text: "VerifyForSignatureImplementation is \(url) and the params are \(param)")
        
        ServerProcessor().request(.get,url, parameters:param, encoding: .queryString, authorize :true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String,_ info:TwillioTokenInfo?)->())) {
        
        Log.echo(key: "twillio", text: " VerifyForSignatureImplementation supported chats are  ==>  \(String(describing: response))")
        
        guard let rawInfo = response
            else{
                completion(false, "",nil)
                return
        }

        if(!success){
            
            let message = "some error occurred"
            completion(false, message,nil)
            return
        }
        
        let data = TwillioTokenInfo(info:rawInfo)
                
        Log.echo(key: "twillio", text: "Time is \(String(describing: data.time))")
        Log.echo(key: "twillio", text: "Room is \(String(describing: data.room))")
        Log.echo(key: "twillio", text: "identity is \(String(describing: data.identity))")
        Log.echo(key: "twillio", text: "Token is \(String(describing: data.token))")
                
        completion(true, "",data)
        return
    }
}
