//
//  SubmitCallReviewProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 21/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SubmitCallReviewProcessor{
    
    //{"comments":"hello","rating":4,"callscheduleId":2271,"analystId":36,"userId":50}
    
    public func submit(comments : String, rating:CGFloat,callscheduleId : Int,analystId:String,userId:String, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/callSurvey"
        
        var params = [String : Any]()
        
        params["comments"] = comments
        params["rating"] = rating
        params["callscheduleId"] = callscheduleId
        params["analystId"] = analystId
        params["userId"] = userId
        
        Log.echo(key: "yud", text: "My sended Dict is \(params)")
        
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding,authorize :true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){       
        
        Log.echo(key: "yud", text: "Response is \(response)")
        
        guard let rawInfo = response
            else{
                completion(false, "",  nil)
                return
        }
        completion(true, "",  nil)
        return
//        if(!success){
//            let message = rawInfo["message"].stringValue
//            completion(false, message, nil)
//            return
//        }
//        completion(true, "", nil)
//        return
    }
}
