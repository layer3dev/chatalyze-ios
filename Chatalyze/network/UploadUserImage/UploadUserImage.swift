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
    
    //https://dev.chatalyze.com/api/users/36/uploads/
    
    func uploadImage(image : UIImage?, completion : @escaping ((_ success : Bool, _ info : JSON?)->())){
        
        var url = "https://dev.chatalyze.com/api/users/"
        url = url + "\(SignedUserInfo.sharedInstance?.id ?? "0")"+"/uploads/"
        
        Log.echo(key: "yud", text: "uploading image url is \(url)")
        
        guard let image = image
            else{
                completion(false, nil)
                return
        }
        guard let data = UIImageJPEGRepresentation(image, 1.0)
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
        
        var url = "https://dev.chatalyze.com/api/users/"
        url = url + "\(userId)"+"/uploads/"
        
        Log.echo(key: "yud", text: "uploading image url is \(url)")
        
        guard let imageData = UIImagePNGRepresentation(image)
            else{
                completion(false)
                return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        Alamofire.upload(multipartFormData : { multipartFormData in
            multipartFormData.append(imageData, withName: "file",
                                     fileName: "file", mimeType: "image/png")
            
            for (key, value) in params {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
        },
                         usingThreshold : 0, to : url,
                         method : .put,
                         headers :  ["Authorization" : (SignedUserInfo.sharedInstance?.accessToken ?? "")],
                         encodingCompletion : { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progressInfo) in
                                    DispatchQueue.main.async {
                                        let percent =  progressInfo.fractionCompleted
                                        progress(Double(percent))
                                    }
                                })
                                
                                upload.validate()
                                upload.responseJSON { response in
                                    Log.echo(key: "yud", text: "Upload image response is \(response)")
                                    completion(true)
                                }
                            case .failure(let encodingError):
                                Log.echo(key: "", text:encodingError)
                                completion(false)
                            }
                            
        })
    }
}
