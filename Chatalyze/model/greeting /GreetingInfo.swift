//
//  GreetingInfo.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


//{"profilePic":null,"avatars":null,"id":2,"firstName":"Analyst","middleName":null,"lastName":"User","description":"testyr","ememorabiliaEnabled":false,"dob":null,"gender":"male","yob":"1961","address":null,"eventMobReminder":null,"mobile":null,"countryCode":null,"phone":null,"zipcode":"11111","meta":null,"createdAt":"2017-10-27T07:35:14.118Z","updatedAt":"2018-05-05T04:50:10.721Z","deletedAt":null,"email":"analyst@test.com","roleId":2,"twitterId":null,"lastLogin":"2018-05-05T04:50:10.721Z","isDeactivated":false,"stripe_id":null,"isTestAccount":false,"passwordUpdatedOn":null,"greetingInfo":{"id":1,"price":40,"currency":"dollar","immediateSystem":false,"analystId":2,"cycleDays":168,"maxGreetings":1,"activated":true,"start":"2018-03-26T18:30:00.000Z","createdAt":"2017-11-16T07:06:31.339Z","updatedAt":"2018-04-05T07:20:51.213Z","deletedAt":null},"receiver":[],"defaultImage":{"url":"https://s3-us-west-2.amazonaws.com/chatalyze/defaultimages/1519111906038_.png"},"blankReset":false,"href":"/users/2","greetingPrice":40}

class GreetingInfo: NSObject {
 
    var id : Int?
    var greetingImageUrl:String?
    var firstName:String?
    var lastName:String?
    var _start : String?
    var startDate : Date?
    var endDate : Date?
    var _end : String?
    var youtubeURL : String?
    var userId : Int?
    var title : String?
    var eventDescription : String?
    var duration : Int?
    var price : Int?
    var backgroundcolor : String?
    var bordercolor : String?
    var textcolor : String?
    var cancelled : Bool?
    var notified : String?
    var started : String?
    var groupId : String?
    var paymentTransferred : Bool?
    var leadPageUrl : String?
    var eventBannerUrl : String?
    var isPrivate : Bool?
    //    var tag : Tag? //:todo
    var isFree : Bool?
    var eventFeedbackInfo : String?
    var createdAt : String?
    var updatedAt : String?
    var deletedAt : String?
    var user : UserInfo?
    var href : String?
    
    
    override init(){
        super.init()
    }
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?) {
        
        guard let json = info
            else{
                return
        }
        id = json["id"].int
        if let defultImageInfoDict = json["defaultImage"].dictionary{
            if let imageURL = defultImageInfoDict["url"]?.string{
                greetingImageUrl = imageURL
            }
        }
        
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue

        if let greetingInfo = json["greetingInfo"].dictionary{
            if let price = greetingInfo["price"]?.int{
                self.price = price
            }
        }
    }
    
    var name:String?{
        get{
            var _name = ""
            if let first = firstName{
                _name = first
            }
            if let last = lastName{
                _name = _name+" "+last
            }
            return _name
        }
    }
}
