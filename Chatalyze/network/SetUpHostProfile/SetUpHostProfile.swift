//
//  SetUpHostProfile.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SetUpHostProfile{
    
    func uploadImageFormatData(image : UIImage, includeToken : Bool,  params : [String : String] = [String : String](), progress : @escaping (Double)->(), completion : @escaping (Bool)->()){
        
        guard  let userId = SignedUserInfo.sharedInstance?.id else {
            completion(false)
            return
        }
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        url = url + "\(userId)"+"/uploads/"
        guard let imageData = image.pngData()
            else{
                completion(false)
                return
        }
        
        Log.echo(key: "yud", text: "uploading image url is \(url) and the param is \(params)")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        Alamofire.upload(multipartFormData : { multipartFormData in
            multipartFormData.append(imageData, withName: "file",
                                     fileName: "blob", mimeType: "image/png")
            
            for (key, value) in params {
                multipartFormData.append((value.data(using: .utf8)) ?? Data(), withName: key)
            }
        },
                         usingThreshold : 0, to : url,
                         method : .put,
                         headers :  ["Authorization" : (getAuthorizationToken())],
                         encodingCompletion : { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progressInfo) in
                                    DispatchQueue.main.async {
                                        let percent =  progressInfo.fractionCompleted
                                        progress(Double(percent))
                                    }
                                })
                                
                                upload.validate(statusCode: 200..<300).responseJSON { response in
                                    
                                    if response.error == nil{
                                        Log.echo(key: "yud", text: "Upload image response is \(response)")
                                        //completion(true)
                                        self.updateDescription(params: params, completion: completion)
                                    }
                                    
                                    Log.echo(key: "yud", text: "Error in response is \(String(describing: response.error))")
                                    completion(false)
                                }
                            case .failure(let encodingError):
                                
                                Log.echo(key: "yud", text:"Encoding error is \(encodingError)")
                                completion(false)
                            }
                            
        })
    }
    
    private func getAuthorizationToken()->String{
        
        guard let info = SignedUserInfo.sharedInstance
            else{
                return ""
        }
        
        let token = "Bearer " + (info.accessToken ?? "")
        Log.echo(key: "yud", text: token)
        return token
    }
    
    func updateDescription(params:[String:String],completion : @escaping (Bool)->()){
        
        self.edit(params: params) { (success, error, response) in
            completion(success)
        }
    }
}


extension SetUpHostProfile{
    
    public func edit(params:[String:String], completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        if let id = SignedUserInfo.sharedInstance?.id{
            url = url+"\(id)"
        }else{
            completion(false ,"id not found",nil)
        }
        
        Log.echo(key: "yud", text: "My sended Dict is\(params) and the url is \(url)")
        
        ServerProcessor().request(.put, url, parameters: params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : JSON?)->())){
        
        Log.echo(key: "yud", text: "Response in the Edit Profile  \(response)")
        
        Log.echo(key: "yud", text: "Email Signin ==>  \(success)")
        guard let rawInfo = response
            else{
                completion(false, "",  nil)
                return
        }
        if(!success){
            let message = rawInfo["message"].stringValue
            completion(false, message, nil)
            return
        }
        completion(true, "", nil)
        return
    }
}
