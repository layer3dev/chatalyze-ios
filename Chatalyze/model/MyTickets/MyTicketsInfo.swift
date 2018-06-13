//
//  MyTicketsInfo.swift
//  Chatalyze
//
//  Created by Mansa on 24/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

//{
//    "callscheduleId" : 1873,
//    "user" : {
//        "passwordUpdatedOn" : "2018-05-17T11:20:55.000Z",
//        "href" : "\/users\/153",
//        "blankReset" : false,
//        "email" : "naina@test.com",
//        "createdAt" : "2018-05-02T10:34:32.720Z",
//        "roleId" : 3,
//        "lastLogin" : "2018-05-24T11:40:21.841Z",
//        "isTestAccount" : false,
//        "twitterId" : null,
//        "id" : 153,
//        "deletedAt" : null,
//        "updatedAt" : "2018-05-24T11:40:21.841Z",
//        "isDeactivated" : false,
//        "stripe_id" : "cus_CsSxXKyGNtvmpj"
//    },
//    "href" : "\/bookings\/calls\/5625",
//    "mobile" : null,
//    "createdAt" : "2018-05-24T11:40:31.012Z",
//    "userId" : 153,
//    "end" : "2018-05-24T11:44:00.000Z",
//    "start" : "2018-05-24T11:42:00.000Z",
//    "bordercolor" : "#f0ff00",
//    "id" : 5625,
//    "isPublic" : false,
//    "deletedAt" : null,
//    "countryCode" : null,
//    "updatedAt" : "2018-05-24T11:40:32.804Z",
//    "callschedule" : {
//        "href" : "\/schedules\/calls\/1873",
//        "tag" : {
//            "categoryId" : null,
//            "subCategoryId" : null
//        },
//        "isPrivate" : false,
//        "userId" : 11,
//        "start" : "2018-05-24T11:34:00.000Z",
//        "bordercolor" : "#f0ff00",
//        "groupId" : "event_production_1873_1527161506251",
//        "deletedAt" : null,
//        "started" : "2018-05-24T11:32:02.000Z",
//        "cancelled" : false,
//        "id" : 1873,
//        "title" : "Ravinder",
//        "duration" : "2",
//        "user" : {
//            "passwordUpdatedOn" : null,
//            "middleName" : null,
//            "href" : "\/users\/11",
//            "blankReset" : false,
//            "meta" : null,
//            "profilePic" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/200X200\/RavinderYadav__111524204124639_200X200",
//            "lastName" : " ",
//            "roleId" : 2,
//            "zipcode" : "34544",
//            "twitterId" : null,
//            "deletedAt" : null,
//            "id" : 11,
//            "countryCode" : 91,
//            "phone" : null,
//            "eventMobReminder" : true,
//            "isDeactivated" : false,
//            "email" : "rv@rv.com",
//            "mobile" : "4545454545",
//            "createdAt" : "2017-11-07T12:27:52.621Z",
//            "address" : null,
//            "description" : "Ravi",
//            "gender" : "male",
//            "lastLogin" : "2018-05-24T11:27:00.703Z",
//            "ememorabiliaEnabled" : false,
//            "avatars" : {
//                "200X200" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/200X200\/RavinderYadav__111524204124639_200X200",
//                "50X50" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/50X50\/RavinderYadav__111524204124639_50X50",
//                "400X400" : "https:\/\/s3-us-west-2.amazonaws.com\/chatalyze\/users\/avatars\/400X400\/RavinderYadav__111524204124639_400X400"
//            },
//            "isTestAccount" : false,
//            "yob" : "1995",
//            "updatedAt" : "2018-05-24T11:27:00.703Z",
//            "firstName" : "Analystt One",
//            "stripe_id" : null,
//            "dob" : null
//        },
//        "eventFeedbackInfo" : null,
//        "eventBannerUrl" : null,
//        "createdAt" : "2018-05-24T11:31:46.238Z",
//        "youtubeURL" : null,
//        "description" : "Test",
//        "emptySlots" : null,
//        "paymentTransferred" : false,
//        "end" : "2018-05-24T13:04:00.000Z",
//        "price" : 99,
//        "notified" : null,
//        "isFree" : false,
//        "leadPageUrl" : null,
//        "updatedAt" : "2018-05-24T11:32:02.365Z",
//        "backgroundcolor" : "#dd002e",
//        "textcolor" : "#000000"
//    },
//    "backgroundcolor" : "#dd002e",
//    "slotNo" : 1,
//    "textcolor" : "#000000"
//}

class MyTicketsInfo: NSObject {
   
    var eventTicketId : String?
    var userId:String?
    var chatNumber:String?
    var startTime:String?
    var endTime:String?
    var startDate:String?
    var eventTitle:String?
    var callScheduleId:String?
    var price:String?
    
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
        self.eventTicketId = json["id"].stringValue
        self.userId = json["userId"].stringValue
        self.chatNumber = json["slotNo"].stringValue
        self._endTime = json["end"].stringValue
        self._startTime = json["start"].stringValue
        self.callScheduleId = json["callscheduleId"].stringValue
        if let callScheduleInfo = json["callschedule"].dictionary{
            self.eventTitle = callScheduleInfo["title"]?.stringValue
            self.price = callScheduleInfo["price"]?.stringValue
            self.price = callScheduleInfo["price"]?.stringValue
        }
    }
    
    
    var _startTime:String{
        
        get{
           return startTime ?? ""
        }
        set{
            let date = newValue
            
            startTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
            
            startDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd, yyyy")
            
            startTime = "\(startTime ?? "")-\(endTime ?? "")"
        }
    }
    
    var _endTime:String{
        
        get{
            return endTime ?? ""
        }
        set{
            let date = newValue
            endTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
        }
    }
}
