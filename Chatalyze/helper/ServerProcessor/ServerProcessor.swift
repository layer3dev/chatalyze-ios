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
    
    private var sessionManager : SessionManager?
    
    init(){
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "test.example.com": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            ),
            "insecure.expired-apis.com": .disableEvaluation
        ]
        
        let sessionManager = SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        self.sessionManager = sessionManager
    }
    
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
        case customGETEncoding
        
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
            case .customGETEncoding:
                return CustomGetEncoding()
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
        
        Log.echo(key: "yud", text: "param => " + (URLString))
        Log.echo(key: "yud", text: "param in server Processor=> " + (parameters?.JSONDescription() ?? ""))
        
        let request = Alamofire.request(URLString, method : method.libHttpMethod(), parameters: parameters, encoding: encoding.libEncoding(), headers: headers)
        self.requestRef = request
        
        request
            .validate()
            .validate(statusCode: 200 ..< 300)
            .responseJSON { (response) in
               
                Log.echo(key: "yud", text: "Response data from the server is  => \(response)")
                
                DispatchQueue.main.async(execute: {
                 
                    self.handleResponse(response)
                    return
                })
                return
        }
        
        //Todo: Fix the issue with callback
    }
    
    fileprivate func getAuthorizationToken()->String{
        
        guard let info = SignedUserInfo.sharedInstance
            else{
                return ""
        }
        
        let token = "Bearer " + (info.accessToken ?? "")
        Log.echo(key: "yud", text: token)
        return token
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
        
//        if response.error != nil{
//
//            //Error and the failure cases are same.
//            if let data = response.data{
//
//                respond(success: false, response: try? JSON(data : data))
//                return
//            }
//            respond(success: false, response: nil)
//            return
//        }
        
        
        Log.echo(key: "yud", text: "Status code is \(response.response?.statusCode)")
        
        if let data = response.data{
                   
            let responseData = String(data: data , encoding: String.Encoding.utf8)
        }
        
        if(response.response?.statusCode == 401 && self.authorize){
            
            Log.echo(key: "yud", text: "Signing out due to the status code 401")
            
            self.signout()
            respond(success: false, response: nil)
            return
        }
        
        guard let senddata = response.data
            else{
                respond(success: false, response: nil)
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
        
        RootControllerManager().signOut {            
        }
        return
        
        /*guard let controller = RootControllerManager.getRootController()
         else{
         RootControllerManager.signOutAction(completion: nil)
         return;
         }
         controller.alert(withTitle: "Session Timed out", message: "Your session has timed out. Please signin again to continue!", successTitle: "Ok", rejectTitle: "", showCancel: false) { (success) in
         RootControllerManager.signOutAction(completion: nil)
         return;
         }*/
    }
    private func extractToken(httpResponse : HTTPURLResponse?){
       
        let headerInfo = httpResponse?.allHeaderFields
        Log.echo(key: "token", text: "headerInfo extracted ==>  \(headerInfo)")
        guard let accessToken = headerInfo?["x-session-token"] as? String
            else{
                Log.echo(key: "token", text: "accessToken not found")
                return
        }
        guard let instance = SignedUserInfo.sharedInstance
            else{
                Log.echo(key: "token", text: "user instance not found")
                return
        }
        Log.echo(key: "token", text: "token extracted ==>  " + accessToken)
        instance.accessToken = accessToken
    }
    
    struct CustomGetEncoding: ParameterEncoding {
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            
            var request = try URLEncoding().encode(urlRequest, with: parameters)
            request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
            Log.echo(key: "yud", text: "Request is\(request)")
            return request
        }
    }
}
