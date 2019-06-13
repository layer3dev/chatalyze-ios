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
       
        Log.echo(key: "yud", text: "direcy sat is \(String(describing: json["started"]?.stringValue))")
      
        Log.echo(key: "yud", text: "direcy exp is \(String(describing: json["expPayoutDate"]?.stringValue))")
        
        setDate(startDate:json["started"]?.stringValue, expectedDate:json["expPayoutDate"]?.stringValue)
    }
    
    func setDate(startDate:String?, expectedDate:String?){
        
        if let startLocal = startDate{
            Log.echo(key: "yud", text: "data during the fetch \(String(describing: DateParser.UTCStringToDate(startLocal)))")
            self.createdDate = DateParser.UTCStringToDate(startLocal)
            Log.echo(key: "yud", text: "data after fetch is  \(String(describing: self.createdDate))")
        }
        
        if let startLocalExp = expectedDate{
            self.payoutDate = DateParser.UTCStringToDate(startLocalExp)
        }
    }
}
