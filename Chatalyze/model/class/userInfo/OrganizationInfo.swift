//
//  OrganizationInfo.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/03/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//



//organization =     {
//    adminId = 1858;
//    confirmationEmail = 1;
//    createdAt = "2020-05-19T04:32:50.745Z";
//    customTermsEnabled = 1;
//    deletedAt = "<null>";
//    id = 1;
//    name = VidCon;
//    removeLogo = 0;
//    updatedAt = "2021-03-02T06:10:47.465Z";
//}
import Foundation
import SwiftyJSON

class OrganizationInfo :NSObject{
    
    
    var removeLogo : Bool?
    
    
    override init(){
        super.init()
    }
    
    init(userInfoJSON : JSON?){
        super.init()
    
        fillInfo(info: userInfoJSON)
    }
    
    func fillInfo(info : JSON?){
        
        guard let info = info?.dictionary
            else{
                return
        }
        
        self.removeLogo = info["removeLogo"]?.boolValue
        
    }
    
}
