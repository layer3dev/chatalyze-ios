//
//  ExtendChatService.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 04/03/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
    
    
class ExtendChatService {
    
    
    func sendRequest(id : String, completion : @escaping ((_ success : Bool, _ response : String?)->())){
        
       
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/\(id)/extend"
        
        
        ServerProcessor().request(.put, url, encoding: .defaultEncoding) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
        
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : String?)->())){
        
        
        if(!success){
            completion(false, nil)
            return
        }
        
        Log.echo(key: "vijayExtendChat", text: "Resonse of Fetch Info in extend \(String(describing: response))")
        let message = "Chat extended successfully".localized() ?? ""
        completion(true, message)
        return
    }
}
