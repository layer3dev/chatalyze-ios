//
//  MemoriesInfo.swift
//  Chatalyze
//
//  Created by Mansa on 19/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class MemoriesInfo: NSObject {
    
    /*
    "id":1610,"userId":50,"analystId":36,"screenshot":"https://s3-us-west-2.amazonaws.com/chatalyze/defaultimages/1519640038601_.png","signed":false,"requestedAutograph":true,"defaultImage":true,"text":null,"color":null,"paid":false,"isPrivate":false,"sharedOn":false,"isImplemented":false,"callbookingId":4735,"callScheduleId":1623,"amount":0,"viewedAt":null,"createdAt":"2018-05-01T06:56:31.235Z","updatedAt":"2018-05-01T06:56:32.149Z","deletedAt":null,"sender":{"id":50,"email":"jack@test.com","roleId":3,"password":"{\"hash\":\"QD40Vwc/0v7UWa9rGyh2evhGoqTFP+9QS1rTNe9qxOgWpCv1jVvGQpJlTlwxqshK2L/RRwPC/xuS59H0mXj7/bOM\",\"salt\":\"O7HZ26Fi4pz+ae72UUtE5PblPUspZNciT3T2zgxrbL3HUC0ZGiVaH/tvC3mdMTpse6wzJrr2uqz3a9vKzrbXHPdf\",\"keyLength\":66,\"hashMethod\":\"pbkdf2\",\"iterations\":519908}","googleId":null,"facebookId":null,"twitterId":null,"lastLogin":"2018-05-18T07:58:24.637Z","isDeactivated":false,"stripe_id":"cus_C9Bo24YJYpP9z2","isTestAccount":false,"passwordUpdatedOn":null,"createdAt":"2018-01-16T12:19:02.170Z","updatedAt":"2018-05-18T07:58:24.638Z","deletedAt":null,"usermetum":{"profilePic":null,"avatars":null,"id":50,"firstName":"jack","middleName":null,"lastName":" ","description":null,"ememorabiliaEnabled":false,"dob":null,"userId":50,"gender":"male","yob":null,"address":"Apple Street","eventMobReminder":true,"mobile":"8686868686","countryCode":null,"phone":"8686868686","zipcode":"10001","meta":null,"createdAt":"2018-01-16T12:19:02.181Z","updatedAt":"2018-05-17T11:49:21.910Z","deletedAt":null}},"reciever":{"id":36,"email":"yudhisther@mansainfotech.com","roleId":2,"password":"{\"hash\":\"6yRfTlHsaycW+3AUn0owQul/Nvk68F/5RN4QNcKMOW4JDkq9P503E15VfDABH8mhQwn01yJj8JRry8/FSsvcbk1J\",\"salt\":\"cDWp2Z1iJXWr54SRImTeW64u3f/iJ971EGWZaMuNOnqkCWHY/hO9vP8s3Zr8cmlBInPqIdV4MMh4xcYLv/US+ecx\",\"keyLength\":66,\"hashMethod\":\"pbkdf2\",\"iterations\":43599}","googleId":null,"facebookId":null,"twitterId":null,"lastLogin":"2018-05-17T09:03:00.519Z","isDeactivated":false,"stripe_id":null,"isTestAccount":false,"passwordUpdatedOn":null,"createdAt":"2017-12-21T10:45:57.976Z","updatedAt":"2018-05-17T09:03:00.520Z","deletedAt":null,"usermetum":{"profilePic":null,"avatars":null,"id":36,"firstName":"Yudi","middleName":null,"lastName":" ","description":"I am Good","ememorabiliaEnabled":false,"dob":null,"userId":36,"gender":"male","yob":null,"address":"Sector 71","eventMobReminder":false,"mobile":null,"countryCode":null,"phone":"7888502101","zipcode":"10001","meta":null,"createdAt":"2017-12-21T10:45:57.998Z","updatedAt":"2017-12-21T10:45:58.003Z","deletedAt":null}},"callbooking":{"id":4735,"start":"2018-05-01T06:56:00.000Z","end":"2018-05-01T06:59:00.000Z","slotNo":2,"callscheduleId":1623,"userId":50,"isPublic":false,"bordercolor":"#f0ff00","backgroundcolor":"#dd002e","textcolor":"#000000","countryCode":null,"mobile":null,"createdAt":"2018-05-01T06:55:19.633Z","updatedAt":"2018-05-01T06:55:21.945Z","deletedAt":null}
    */
    var id : String?
    var userId:String?
    var analystId:String?
    var screenShotUrl:String?
    
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
        
        self.id = json["id"].stringValue
        self.userId = json["userId"].stringValue
        self.analystId = json["analystId"].stringValue
        self.screenShotUrl = json["screenshot"].stringValue
    }
    
}
