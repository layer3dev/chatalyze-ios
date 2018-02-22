//
//  ServerProcessor.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerProcessor{
    
    enum httpMethod {
        case get
        case post
        case put
        case delete
        
        public func libHttpMethod()->Alamofire.HTTPMethod{
            switch self {
            case .get:
                return Alamofire.HTTPMethod.get
            case .post:
                return Alamofire.HTTPMethod.post
            case .put:
                return Alamofire.HTTPMethod.put
            case .delete:
                return Alamofire.HTTPMethod.delete
            }
        }
    }
    
    enum encoding {
        
        case defaultEncoding
        case httpBody
        case queryString
        case jsonEncoding
        
        public func libEncoding()->Alamofire.ParameterEncoding{
            
            switch self {
            case .defaultEncoding:
                return URLEncoding.default
            case .httpBody:
                return URLEncoding.httpBody
            case .queryString:
                return URLEncoding.queryString
            case .jsonEncoding:
                return JSONEncoding.default
            }
        }
    }
    
    fileprivate var requestRef : Request?
    fileprivate var completion : ((_ success : Bool, _ response : JSON?)->())?
    fileprivate var authorize = false
    
    func cancelRequest(_ ignoreResponse : Bool = true){
        if(ignoreResponse){
            completion = nil
        }
        requestRef?.cancel()
    }

    func request(
        _ method: httpMethod,
        _ URLString: String,
        parameters: [String: Any]? = nil,
        encoding: encoding = .defaultEncoding,
        headers: [String: String]? = nil, authorize : Bool = false,
        completion : @escaping ((_ success : Bool, _ response : JSON?)->())){
        
        self.completion = completion
        self.authorize = authorize
        var headers = headers ?? [String : String]()
        
        if(authorize){
            headers["Authorization"] = getAuthorizationToken()
        }
        
        Log.echo(key: "token", text: "param => " + (URLString))
        Log.echo(key: "yud", text: "param in server Processor=> " + (parameters?.JSONDescription() ?? ""))
        let request = Alamofire.request(URLString, method : method.libHttpMethod(), parameters: parameters, encoding: encoding.libEncoding(), headers: headers)
        self.requestRef = request
       
        request
        .validate()
        .validate(statusCode: 200 ..< 300)
            .responseJSON { (response) in
                DispatchQueue.main.async(execute: {
                    self.handleResponse(response)
                    return
                })
                return
        }
    }
    
    fileprivate func getAuthorizationToken()->String{
        //:todo
        /*guard let info = SignedUserInfo.sharedInstance
            else{
                return ""
        }
        
        let token = "Bearer " + (info.accessToken ?? "")
        Log.echo(key: "token", text: token)
        return token*/
        return ""
    }
    
    fileprivate func respond(success : Bool, response : JSON?){
        
        guard let completion = self.completion
            else{
                return
        }
        completion(success, response)
        self.completion = nil
    }
    
    fileprivate func handleResponse(_ response : Alamofire.DataResponse<Any>){
        
        if let data = response.data{
            
            let responseData = String(data: data , encoding: String.Encoding.utf8)
            Log.echo(key: "yud", text: "param => \(responseData)")
        }
        
        if(response.response?.statusCode == 401 && self.authorize){
            
            self.signout()
            respond(success: false, response: nil)
            return;
        }
        
        guard let senddata = response.data
            else{               
                return
        }
        
        if(response.result.isFailure){
            respond(success: false, response: try? JSON(data : senddata))
            return
        }
        
        if(response.result.isSuccess && self.authorize){
            extractToken(httpResponse: response.response)
        }
        
        guard let data = response.data
            else{
                respond(success: response.result.isSuccess, response: nil)
                return
        }
        
        respond(success: response.result.isSuccess, response: try? JSON(data : data))
        return
    }
    
    fileprivate func signout(){
        
         //RootControllerManager.signOutAction(completion: nil)
         return
        
        
    }
    private func extractToken(httpResponse : HTTPURLResponse?){
        let headerInfo = httpResponse?.allHeaderFields
        Log.echo(key: "token", text: "headerInfo extracted ==>  \(String(describing: headerInfo))")
        guard (headerInfo?["x-session-token"] as? String) != nil
            else{
                Log.echo(key: "token", text: "accessToken not found ")
                return
        }
        //:todo
        /*guard let instance = SignedUserInfo.sharedInstance
            else{
                Log.echo(key: "token", text: "user instance not found ")
                return
        }
        Log.echo(key: "token", text: "token extracted ==>  " + accessToken)
        instance.accessToken = accessToken*/
    }
}
