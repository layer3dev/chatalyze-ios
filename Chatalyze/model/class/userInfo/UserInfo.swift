//
//  UserInfo.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfo: NSObject {
    
    @objc enum genderType : Int {
       
        case male = 1
        case female = 2
    }
    
    @objc enum roleType : Int {
    
        case user = 0
        case analyst = 1

        public static func role(withRoleId role : String?)->roleType{
         
            let roleId = role ?? "3"
            
            switch roleId {
            case "2":
                return .analyst
            default:
                return .user
            }
        }
    }
    
    var id : String?
    var firstName : String?
    var middleName : String?
    var lastName : String?
    var userDescription : String?
    var yob : String?
    var gender : String?
    var address : String?
    var phone : String?
    var mobile : String?
    var zipCode : String?
    var email : String?
    var roleId : String?
    var joiningDate : String?
    var profileImage : String?
    var profileThumbnail : String?
    var defaultImage : HostDefaultScreenshot?
    var eventMobReminder:Bool = false
    var emailNotification:Bool = false
    var isOnline = false
    var countryCode:String = ""
    var allowFreeSession:Bool? = false
    var shouldAskForPlan:Bool? = false
    var planIdentifier:String?
    var planId:String?
    var isTrialPlanActive:Bool?
    var isSubscriptionPlanExists:Bool?
    var isTermsAccepted : Bool?
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
        id = info["id"]?.stringValue
        firstName = info["firstName"]?.stringValue
        middleName = info["middleName"]?.stringValue
        lastName = info["lastName"]?.stringValue
        userDescription = info["description"]?.stringValue
        yob = info["yob"]?.stringValue
        gender = info["gender"]?.stringValue
        address = info["address"]?.stringValue
        mobile = info["mobile"]?.stringValue
        phone = info["mobile"]?.stringValue
        zipCode = info["zipCode"]?.stringValue
        joiningDate = info["createdAt"]?.stringValue
        email = info["email"]?.stringValue
        roleId = info["roleId"]?.stringValue
        let avatars = info["avatars"]
        profileImage = info["profilePic"]?.stringValue
        profileThumbnail = avatars?["200X200"].stringValue
        defaultImage = HostDefaultScreenshot(info: info["defaultImage"])
        self.eventMobReminder = info["eventMobReminder"]?.boolValue ?? false
        self.emailNotification  = info["emailNot"]?.boolValue ?? false
        self.isTermsAccepted = info["termsAccepted"]?.boolValue
        self.countryCode =  (info["countryCode"]?.stringValue) ?? ""
        self.allowFreeSession  = info["allowFreeSession"]?.boolValue
        if let meta = info["meta"]?.dictionary{
            self.shouldAskForPlan = meta["askPlan"]?.boolValue
        }else{
            self.shouldAskForPlan = false
        }
        
        if let userSubscriptionPlan = info["userSubscriptionPlan"]?.dictionary {
           
            self.isSubscriptionPlanExists = true
            self.isTrialPlanActive = userSubscriptionPlan["isTrial"]?.boolValue
            if let subscriptionPlan = userSubscriptionPlan["subscriptionPlan"]?.dictionary{
                
                self.planIdentifier = subscriptionPlan["identifier"]?.stringValue
                self.planId = subscriptionPlan["id"]?.stringValue
            }
        }else{
            isSubscriptionPlanExists = false
        }        
        updateSideMenuInfo()
    }
}

extension UserInfo{
    
    @objc var genderType : genderType {
       
        get{
            if(gender == "female"){
                
                return .female
            }
            return .male
        }
        set{
            if(newValue == .female){
                gender = "female"
                return
            }
            gender = "male"
        }
    }
    
    //last name field is no longer used, but server is storing full name in first name field
    @objc var fullName : String{
        get{
            return self.firstName ?? ""
        }
    }
    
    fileprivate func getCurrentYear()->Int{
        
        let date  = Date()
        let dateInfo = DateParser.getDateComponentsFromDate(date)
        return dateInfo.year ?? 0;
    }
    
    @objc var age : String{
        
        get{
            let yob = Int(self.yob ?? "") ?? 0
            let currentYear = getCurrentYear()
            let age = currentYear - yob
            return String(age)
        }
    }
    
    var joiningDateFormatted : String{
        
        guard let joiningDate = self.joiningDate
            else{
                return ""
        }
        
        let formattedDate  = DateParser.parseToFormattedData(joiningDate)

        return formattedDate ?? ""
    }
    
    @objc var role : roleType{
        
        get{
            return roleType.role(withRoleId: self.roleId)
        }
    }
    
    @objc var hashedId : String{
        get{
            return UniqueUserIdentifier().generateUniqueIdentifier(userId: id)
        }
    }
}


extension UserInfo{
    
    func updateSideMenuInfo(){
        RootControllerManager().getCurrentController()?.menuController?.updateMenuInfo()
    }
}
