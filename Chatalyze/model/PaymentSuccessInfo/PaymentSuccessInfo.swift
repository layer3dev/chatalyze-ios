//
//  PaymentSuccessInfo.swift
//  Chatalyze
//
//  Created by Mansa on 04/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class PaymentSuccessInfo: NSObject {
    
    var slotNumber:String?
    var startTime:String?
    var endTime:String?
    var startDate:String?
    var endDate:String?
    var _startDate:String?
    var _endDate:String?


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
            
            self.startTime = DateParser.convertDateToDesiredFormat(date: startDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "h:mm a" : Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
            
            self.startDate = DateParser.convertDateToDesiredFormat(date: startDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "MMM dd, yyyy" : "dd/MM/yyyy")
            
            self.endDate = DateParser.convertDateToDesiredFormat(date: _endDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "MMM dd, yyyy" : "dd/MM/yyyy")
            
            self.endTime = DateParser.convertDateToDesiredFormat(date: _endDate, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "en" ? "h:mm a" : Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
        }
    }
    
}
