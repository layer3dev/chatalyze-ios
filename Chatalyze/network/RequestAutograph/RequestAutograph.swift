//
//  RequestAutograph.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class RequestAutograph{
    
    public func request(screenshotId : String, hostId : String, completion : @escaping ((_ success : Bool, _ response : ScreenshotInfo?)->())){
        
        //{"analystId":28,"screenshotId":432,"userId":79}
        var params = [String : Any]()
        params["analystId"] = hostId
        params["screenshotId"] = screenshotId
        params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        let url = AppConnectionConfig.webServiceURL + "/screenshots/requestAutograph"
        
        Log.echo(key: "yud", text: "params during the ping \(params)")
        
    
        ServerProcessor().request(.put, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : ScreenshotInfo?)->())){
        
        if(!success){
            completion(false, nil)
            return
        }
        
        Log.echo(key: "response", text: "Resonse of requesting autograph is  \(response)")
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
        
        
        
        let screenshotInfo = ScreenshotInfo(info: info)
        
        Log.echo(key: "screenshotInfo", text: "screenshotInfo info --> \(String(describing: screenshotInfo.id))")
        
        completion(true, screenshotInfo)
        return
    }
}

