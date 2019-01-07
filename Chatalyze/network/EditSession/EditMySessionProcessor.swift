//
//  EditMySessionProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class EditMySessionProcessor {
        
    func uploadEventBannerImage(image : UIImage?,eventId:Int, description:String,completion : @escaping ((_ success : Bool, _ info : JSON?)->())){
        
        //https://dev.chatalyze.com/api/schedules/calls/6336
        
        var url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        
        url = url + "\(eventId)"
        
        Log.echo(key: "yud", text: "uploading image url is \(url)")
        
        guard let image = image
            else{
                completion(false, nil)
                return
        }
        guard let data = image.jpegData(compressionQuality: 1.0)
            else{
                completion(false, nil)
                return
        }
        var params = [String : Any]()
        //  params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        params["file"] = imageBase64
        params["description"] = description
        
        
        Log.echo(key: "yud", text: "uploading image url is \(url) and the params are \(params)")
        
        ServerProcessor().request(.put, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    func uploadEventBanner(eventId:Int, description:String,completion : @escaping ((_ success : Bool, _ info : JSON?)->())){
        
        //https://dev.chatalyze.com/api/schedules/calls/6336
        
        var url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        
        url = url + "\(eventId)"
        
        
        
       
        var params = [String : Any]()
        //  params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        params["description"] = description
        Log.echo(key: "yud", text: "uploading image url is \(url) and the params are \(params)")
        
        
        ServerProcessor().request(.put, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : ((_ success : Bool, _ info : JSON?)->())){
        
        if(!success){
            completion(false, nil)
            return
        }
        
        Log.echo(key: "yud", text: "Upload image response is \(response)")
        
        guard let info = response
            else{
                completion(false, nil)
                return
        }
        
        completion(true, info)
        return
    }
}
