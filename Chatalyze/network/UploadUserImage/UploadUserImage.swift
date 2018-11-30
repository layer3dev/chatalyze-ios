//
//  UploadUserImage.swift
//  Chatalyze
//
//  Created by Mansa on 29/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UploadUserImage{
    
    func uploadImage(image : UIImage?, completion : @escaping ((_ success : Bool, _ info : JSON?)->())){
        

        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        url = url + "\(SignedUserInfo.sharedInstance?.id ?? "0")"+"/uploads/"
        
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
        //        params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        params["file"] = imageBase64
        
        
        ServerProcessor().request(.put, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    
    func deleteUploadedImage(completion : @escaping ((_ success : Bool, _ info : JSON?)->())){
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
        
        url = url + "\(SignedUserInfo.sharedInstance?.id ?? "0")"+"/uploads/"
        
        Log.echo(key: "yud", text: "uploading image url is \(url)")
        
        var params = [String : Any]()
        //        params["userId"] = SignedUserInfo.sharedInstance?.id ?? "0"
        
        ServerProcessor().request(.delete, url, parameters : params, encoding: .jsonEncoding, authorize : true) { (success, response) in
            
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
    
    func uploadImageFormatData(image : UIImage, includeToken : Bool,  params : [String : String] = [String : String](), progress : @escaping (Double)->(), completion : @escaping (Bool)->()){
        
        guard  let userId = SignedUserInfo.sharedInstance?.id else {
            
            completion(false)
            return
        }
        
        var url = AppConnectionConfig.webServiceURL + "/users/"
                
        url = url + "\(userId)"+"/uploads/"
        
//        guard let imageData = UIImageJPEGRepresentation(image, 0.1)
//            else{
//                completion(false)
//                return
//        }
        
        guard let imageData = image.pngData()
            else{
                completion(false)
                return
        }
        
        Log.echo(key: "yud", text: "uploading image url is \(url)")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
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
                                        completion(true)
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
    
//    validate()
//    .validate(statusCode: 200 ..< 300)
//    .responseJSON { (response) in
//    DispatchQueue.main.async(execute: {
//    self.handleResponse(response)
//    return
//    })
//    return
//    }
    
    private func getAuthorizationToken()->String{
        
        guard let info = SignedUserInfo.sharedInstance
            else{
                return ""
        }
        
        let token = "Bearer " + (info.accessToken ?? "")
        Log.echo(key: "yud", text: token)
        return token
    }
}
