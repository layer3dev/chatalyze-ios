//
//  MySessionsInfo.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySessionsInfo: NSObject {
    
    var slotNumber:String?
    var startTime:String?
    var endTime:String?
    var startDate:String?
    var endDate:String?
    var _startDate:String?
    var _endDate:String?

    //    {"countryCode":null,"mobile":null,"start":"2018-06-04T09:07:04.000Z","end":"2018-06-04T09:10:04.000Z","userId":50,"callscheduleId":1971,"bordercolor":"#f0ff00","backgroundcolor":"#dd002e","textcolor":"#000000","slotNo":5,"id":5984,"callschedule":{"id":1971,"start":"2018-06-04T05:40:04.000Z","end":"2018-06-04T17:07:39.000Z","youtubeURL":null,"emptySlots":[],"userId":36,"title":"iOS Testing","description":"dfdsf","duration":"3","price":100,"backgroundcolor":"#dd002e","bordercolor":"#f0ff00","textcolor":"#000000","cancelled":false,"notified":"schedule_updated","started":"2018-06-04T05:36:04.000Z","groupId":"event_production_1971_1528090535739","paymentTransferred":false,"leadPageUrl":null,"eventBannerUrl":null,"isPrivate":false,"tag":{"categoryId":null,"subCategoryId":null},"isFree":false,"eventFeedbackInfo":null,"paymentRuleId":1,"createdAt":"2018-06-04T05:35:35.722Z","updatedAt":"2018-06-04T05:36:04.166Z","deletedAt":null,"user":{"id":36,"email":"yudhisther@mansainfotech.com","roleId":2,"password":"{\"hash\":\"6yRfTlHsaycW+3AUn0owQul/Nvk68F/5RN4QNcKMOW4JDkq9P503E15VfDABH8mhQwn01yJj8JRry8/FSsvcbk1J\",\"salt\":\"cDWp2Z1iJXWr54SRImTeW64u3f/iJ971EGWZaMuNOnqkCWHY/hO9vP8s3Zr8cmlBInPqIdV4MMh4xcYLv/US+ecx\",\"keyLength\":66,\"hashMethod\":\"pbkdf2\",\"iterations\":43599}","googleId":null,"facebookId":null,"twitterId":null,"lastLogin":"2018-06-04T05:35:56.997Z","isDeactivated":false,"stripe_id":null,"isTestAccount":false,"passwordUpdatedOn":null,"createdAt":"2017-12-21T10:45:57.976Z","updatedAt":"2018-06-04T05:35:56.998Z","deletedAt":null,"usermetum":{"profilePic":null,"avatars":null,"id":36,"firstName":"Yudi","middleName":null,"lastName":" ","description":"I am Good","ememorabiliaEnabled":false,"dob":null,"userId":36,"gender":"male","yob":null,"address":"Sector 71","eventMobReminder":false,"mobile":null,"countryCode":null,"phone":"7888502101","zipcode":"10001","meta":null,"createdAt":"2017-12-21T10:45:57.998Z","updatedAt":"2017-12-21T10:45:58.003Z","deletedAt":null}},"paymentRule":{"id":1,"name":"mansa","type":null,"applyTiming":"Immidiately","hostShare":20,"chatalyzeShare":80,"meta":[],"createdAt":"2018-05-29T06:16:24.435Z","updatedAt":"2018-05-29T06:16:24.435Z","deletedAt":null}}}
    
    
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
        
        //Plz do not change the sequence
        self.slotNumber = json["slotNo"].stringValue
        self._startDate = json["start"].stringValue
        self._endDate = json["end"].stringValue
        self._time = json["start"].stringValue
    }
    
    var _time:String{
        
        get{
            return ""
        }
        set{
            
            let startDate = newValue
            
            self.startTime = DateParser.convertDateToDesiredFormat(date: startDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "h:mm a" : Locale.current.languageCode == "zh" ? "下午 h 點 mm 分" : Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
            
            self.startDate = DateParser.convertDateToDesiredFormat(date: startDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "MMM dd, yyyy" : Locale.current.languageCode == "zh" ? "yyyy 年 MM 月 d 日" : "dd/MM/yyyy")
            
            self.endDate = DateParser.convertDateToDesiredFormat(date: _endDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "MMM dd, yyyy" : Locale.current.languageCode == "zh" ? "yyyy 年 MM 月 d 日" : "dd/MM/yyyy")
            
            self.endTime = DateParser.convertDateToDesiredFormat(date: _endDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "h:mm a" : Locale.current.languageCode == "zh" ? "下午 h 點 mm 分" : Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
        }
    }
    
}
