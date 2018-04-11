//
//  ScreenshotInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class ScreenshotInfoFetch{
    
    public func fetchInfo(slotId : Int, completion : @escaping ((_ success : Bool, _ response : [ScreenshotInfo])->())){
        
        //https://dev.chatalyze.com/api/bookings/3267/screenshot/
        let url = AppConnectionConfig.webServiceURL + "/bookings/\(slotId)/screenshot/"
        
        
        ServerProcessor().request(.get, url, encoding: .defaultEncoding, authorize : true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [ScreenshotInfo])->())){
        var infos = [ScreenshotInfo]()
        
        if(!success){
            completion(false, infos)
            return
        }
        
        Log.echo(key: "response", text: "Resonse of ScreenshotInfoFetch \(response)")
        
        guard let rawInfos = response?.arrayValue
            else{
                completion(false, infos)
                return
        }
        
        if(rawInfos.count <= 0){
            completion(false, infos)
            return
        }
        
        
        
        for rawInfo in rawInfos {
            let info = ScreenshotInfo(info: rawInfo)
            infos.append(info)
        }
        
        completion(true, infos)
        return
    }
}
