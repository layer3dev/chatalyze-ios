//
//  FetchReferralUrl.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchReferralUrl{
    
    public func fetch(completion : @escaping ((_ success : Bool, _ response : String?)->())){
        
        if let url = URL(string: AppConnectionConfig.webServiceURL + "/registerlink/referral"){
            
            var request = URLRequest(url: url)
            request.setValue("text/html", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            request.setValue(ServerProcessor().getAuthorizationToken(), forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "POST"
            
            let parameters: [String: Any] = [String: Any]()
            //request.httpBody = parameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    
                    
                    guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {                                              // check for fundamental networking error
                            //print("error", error ?? "Unknown error")
                            completion(false,"")
                            return
                    }
                    
                    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                        completion(false,"")
                        
                        //                    print("statusCode should be 2xx, but is \(response.statusCode)")
                        //                    print("response = \(response)")
                        return
                    }
                    
                    
                    
                    let responseString = String(data: data, encoding: .utf8)
                    //print("responseString = \(responseString)")
                    completion(true,responseString)
                }
            }            
            task.resume()
        
        }else{
            completion(false,"")
        }
        
    }
    
}

