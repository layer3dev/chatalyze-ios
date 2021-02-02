//
//  RequestDefaultImage.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 01/02/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestDefaultImage{

        
        public func fetchInfo(id : String, completion : @escaping ((_ success : Bool, _ response : String?)->())){
            
            //https://chatitat.incamerasports.com/api/screenshots/?analystId=39&limit=5&offset=0
            var url = AppConnectionConfig.webServiceURL + "/schedules/calls/room"
            url += "/" + id
            
            ServerProcessor().request(.get, url, encoding: .defaultEncoding) { (success, response) in
                self.handleResponse(withSuccess: success, response: response, completion: completion)
            }
        }
        
        private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : String?)->())){
            
            
            if(!success){
                completion(false, nil)
                return
            }
            
            let info = response
            Log.echo(key: "yud", text: "Resonse of Fetch Info in defaultImage \(String(describing: response))")
            let defaulImage = info?["user"]["defaultImage"]["url"].stringValue
            completion(true, defaulImage)
            return
        }
    }

