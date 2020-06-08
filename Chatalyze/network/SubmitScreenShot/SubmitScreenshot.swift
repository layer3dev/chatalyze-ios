//
//  SubmitScreenshot.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class SubmitScreenshot{
    
    public func submitScreenshot(params : [String : Any], completion : @escaping ((_ success : Bool, _ response : ScreenshotInfo?)->())){
        
        let url = AppConnectionConfig.webServiceURL + "/screenshots"
        
        ServerProcessor().request(.post, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : ScreenshotInfo?)->())){
  
        Log.echo(key: "yudi", text: "Resonse of submit screenshot  \(String(describing: response))")
        
        if(!success){
            completion(false, nil)
            return
        }
        
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
        
        let screenshotInfo = ScreenshotInfo(info: info)
        
        Log.echo(key: "yudi", text: "screenshotInfo info --> \(String(describing: screenshotInfo.id))")
        
        completion(true, screenshotInfo)
        return
    }
}

