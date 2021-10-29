//
//  AutographUserInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 17/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AutographUserInfo {
    
    var id : String?
    var email : String?
    var roleId : String?
    var password : String?
    var googleId : String?
    var facebookId : String?
    var lastLogin : String?
    var stripeId : String?
    var createdAt : String?
    var updatedAt : String?
    var deletedAt : String?
    var userInfo : UserInfo?
    
    init(){
    }
    
    init(info : JSON?){
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?){
        
        guard let info = info?.dictionary
            else{
                return
        }
        
        id = info["id"]?.stringValue
        email = info["email"]?.stringValue
        roleId = info["roleId"]?.stringValue
        
        password = info["password"]?.stringValue
        googleId = info["googleId"]?.stringValue
        facebookId = info["facebookId"]?.stringValue
        
        lastLogin = info["lastLogin"]?.stringValue
        stripeId = info["stripe_id"]?.stringValue
        createdAt = info["createdAt"]?.stringValue
        
        updatedAt = info["updatedAt"]?.stringValue
        deletedAt = info["deletedAt"]?.stringValue
        
        userInfo = UserInfo(userInfoJSON: info["usermetum"])
    }
    
}
