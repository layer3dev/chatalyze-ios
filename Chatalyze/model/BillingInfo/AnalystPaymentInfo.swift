//
//  AnalystPaymentInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnalystPaymentInfo: NSObject {
    
    var id:String?
    var expectedPayoutAmount:String?
    var payoutDate:Date?
    var createdDate:Date?
    
    override init() {
        super.init()
    }
    
    init(info:JSON?) {
        super.init()
        
        self.fillInfo(info: info)
    }
    
    func fillInfo(info:JSON?){
        
        guard let json = info?.dictionary else{
            return
        }
        
        self.id = json["id"]?.stringValue
        self.expectedPayoutAmount = json["expAmt"]?.stringValue
        self._startDate = json["started"]?.stringValue
        self._expectedDate = json["expPayoutDate"]?.stringValue
    }
    
    
    private var _startDate: String?{
       
        get{
            return ""
        }
        set{
            let date = newValue
            guard let startLocal = date
                else{
                    return
            }
            createdDate = DateParser.UTCStringToDate(startLocal)
        }
    }
    
    private var _expectedDate: String?{
      
        get{
            return ""
        }
        set{
            let date = newValue
            guard let startLocal = date
                else{
                    return
            }
            self.payoutDate = DateParser.UTCStringToDate(startLocal)
        }
    }
    
    
    
}
