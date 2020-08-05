//
//  AppleLogin.swift
//  Chatalyze
//
//  Created by Mansa Mac-3 on 7/31/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//



import Foundation
import SwiftyJSON
import Bugsnag

class AppleLogin{
    
  
  public func signin(clientId:String?,authCode:String?,name: String?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        guard let authCode = authCode
            else{
                completion(false, "Access Denied !", nil)
                return
        }
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/oauth/apple"
    
        var params = [String : Any]()
        
            params["code"] = authCode
            params["clientId"] = clientId
            params["name"] = name
            params["preventSignUp"] = true
        
        Log.echo(key: "dhi", text: "My sended Dict is \(params)")
      
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
            self.handleResponseSignin(withSuccess: success, response: response, completion: completion)
        }
    }
    
    
    private func handleResponseSignin(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "dhi", text: "raw info from Apple Signin ==>  \(response)")
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
        
        Log.echo(key: "token", text: "parse user info now")
        
        let info = SignedUserInfo.initSharedInstance(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        info.save()
        
        Bugsnag.configuration()?.setUser(info.id ?? "", withName:info.firstName ?? "",andEmail:info.email ?? "")
//        Bugsnag.notifyError(NSError(domain:"com.customCrash:SignIn", code:408, userInfo:nil))

        completion(true, "", info)
        return
    }
    
    
  public func signup(clientId:String?,authCode:String?,name:String?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        guard let authCode = authCode
            else{
                completion(false, "Access Denied !", nil)
                return
        }
        
        let url = AppConnectionConfig.webServiceURL + "/authenticate/oauth/apple"
       

        var params = [String : Any]()
        
        params["code"] = authCode
        params["clientId"] = clientId
        params["name"] = name
        params["preventSignUp"] = false
        params["roleId"] = LoginSignUpContainerController.roleId
        
        Log.echo(key: "dhi", text: "My sended Dict is\(params)")
      
        ServerProcessor().request(.post, url, parameters: params, encoding: .jsonEncoding) { (success, response) in
            self.handleResponseSignup(withSuccess: success, response: response, completion: completion)
        }
    }
    
    
    private func handleResponseSignup(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ error : String, _ response : SignedUserInfo?)->())){
        
        Log.echo(key: "dhi", text: "raw info from Apple SignUp ==>  \(String(describing: response))")
        
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
        Log.echo(key: "token", text: "parse user info now")
        
        //isOnBoardShowed is set to true in order to see the onboarding graphics only after each sign up  through facebook. Facebook always treated as the new signUp.
        
        let info = SignedUserInfo.initSharedInstance(userInfoJSON: rawInfo["user"])
        let token = rawInfo["token"].stringValue
        info.accessToken = token
        info.save()
        
        if info.role == .analyst{
            UserDefaults.standard.set(true, forKey: "isHostWelcomeScreenNeedToShow")
        }else{
            UserDefaults.standard.set(true, forKey: "isOnBoardShowed")
        }

        if let id = info.id {
            
            Log.echo(key: "dhi", text: "Alias is calling")
            SEGAnalytics.shared().alias(id)
        }
        SEGAnalytics.shared().identify(info.id, traits: ["name":info.firstName ?? "","email":info.email ?? ""])
        Bugsnag.configuration()?.setUser(info.id ?? "", withName:info.firstName ?? "",
                                         andEmail:info.email ?? "")
//        Bugsnag.notifyError(NSError(domain:"com.customCrash:SignIn", code:408, userInfo:nil))

        completion(true, "", info)
        return
    }
    
}
