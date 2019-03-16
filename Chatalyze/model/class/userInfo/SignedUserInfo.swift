//
//  SignedUserInfo.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignedUserInfo: UserInfo , NSCoding{
    var accessToken : String?
    var notificationCount : Int = 0
    private static var _sharedInstance : SignedUserInfo?
    
    @objc static var sharedInstance : SignedUserInfo?{
        
        get{
            if(_sharedInstance != nil){
                return _sharedInstance
            }
            let instance = retreiveInstance()
            _sharedInstance = instance
            return instance
        }
    }
    
    static let encodingKey = "userInfo"
    static func initSharedInstance(userInfoJSON : JSON?)->SignedUserInfo{
        
        let oldInstance = sharedInstance
        let info = SignedUserInfo(userInfoJSON : userInfoJSON)
        _sharedInstance = info
        info.save()
        info.accessToken = oldInstance?.accessToken
        return info
    }
    
    override init(){
        super.init()
    }
    
    override init(userInfoJSON : JSON?){
        super.init(userInfoJSON: userInfoJSON)
        
    }
    
    override func fillInfo(info : JSON?){
        super.fillInfo(info: info)
        save()
    }
    
    func save(){
        
        let ud = UserDefaults.standard
        let instance = self
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        ud.set(data, forKey: SignedUserInfo.encodingKey)
    }
    
    private static func retreiveInstance()->SignedUserInfo?{
        
        let ud = UserDefaults.standard
        guard let data = ud.object(forKey: encodingKey) as? Data
        else{
            return nil
        }
        let unarc = NSKeyedUnarchiver(forReadingWith: data)
        unarc.setClass(SignedUserInfo.self, forClassName: "SignedUserInfo")
        let signedUserInfo = unarc.decodeObject(forKey: "root") as? SignedUserInfo
        return signedUserInfo
    }
    
    
    required convenience init(coder aDecoder: NSCoder){
        self.init()
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        middleName = aDecoder.decodeObject(forKey: "middleName") as? String
        lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        userDescription = aDecoder.decodeObject(forKey: "description") as? String
        yob = aDecoder.decodeObject(forKey: "yob") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        roleId = aDecoder.decodeObject(forKey: "roleId") as? String
        joiningDate = aDecoder.decodeObject(forKey: "joiningDate") as? String
        profileImage = aDecoder.decodeObject(forKey: "profileImage") as? String
        profileThumbnail = aDecoder.decodeObject(forKey: "profileThumbnail") as? String
        isOnline = aDecoder.decodeBool(forKey: "isOnline")
        accessToken  = aDecoder.decodeObject(forKey: "accessToken") as? String
        eventMobReminder = aDecoder.decodeBool(forKey: "eventMobReminder")
        countryCode = (aDecoder.decodeObject(forKey: "countryCode") as? String) ?? ""
        allowFreeSession = (aDecoder.decodeObject(forKey: "allowFreeSession") as? Bool)
        shouldAskForPlan = (aDecoder.decodeObject(forKey: "shouldAskForPlan") as? Bool)
        planIdentifier = aDecoder.decodeObject(forKey: "planIdentifier") as? String
        planId = aDecoder.decodeObject(forKey: "planId") as? String
        shouldAskForPlan = (aDecoder.decodeObject(forKey: "isTrialPlanActive") as? Bool)
        isSubscriptionPlanExists = (aDecoder.decodeObject(forKey:"isSubscriptionPlanExists") as? Bool)
    }
        
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(middleName, forKey: "middleName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(userDescription, forKey: "description")
        aCoder.encode(yob, forKey: "yob")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(zipCode, forKey: "zipCode")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(roleId, forKey: "roleId")
        aCoder.encode(joiningDate, forKey: "joiningDate")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(profileThumbnail, forKey: "profileThumbnail")
        aCoder.encode(isOnline, forKey: "isOnline")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(eventMobReminder, forKey: "eventMobReminder")
        aCoder.encode(countryCode, forKey: "countryCode")
        aCoder.encode(allowFreeSession, forKey: "allowFreeSession")
        aCoder.encode(shouldAskForPlan, forKey: "shouldAskForPlan")
        aCoder.encode(planIdentifier, forKey: "planIdentifier")
        aCoder.encode(planId, forKey: "planId")
        aCoder.encode(isTrialPlanActive, forKey: "isTrialPlanActive")
        aCoder.encode(isSubscriptionPlanExists, forKey: "isSubscriptionPlanExists")
    }
    
    func clear(){
        
        let ud = UserDefaults.standard
        ud.set(nil, forKey: SignedUserInfo.encodingKey)
        ud.synchronize()
        notificationCount = 0
        SignedUserInfo._sharedInstance = nil
    }
}
