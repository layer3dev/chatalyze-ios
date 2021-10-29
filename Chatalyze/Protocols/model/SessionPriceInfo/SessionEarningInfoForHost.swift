//
//  SessionEarningInfoForHost.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SessionEarningInfoForHost: NSObject {
    
    var totalReceivedAmt:String?
    var expChatalyzeShare:String?
    var transactionFee:String?
    var refundAmount:String?
    var deductFeeFromPlateform:Bool?
    var transferredToOther:String?
    var expOtherShare:String?
    var transferredToHost:String?
    var expHostShare:String?
    var chargedFee:String?
    var netChatalyzeShare:String?
    
    override init() {
        super.init()
    }
    init(info: JSON?){
        super.init()
        
        fillInfo(info: info)
    }
    
    func fillInfo(info:JSON?){
        
        guard let info = info else{
            return
        }
        
        self.totalReceivedAmt = info["totalReceivedAmt"].stringValue
        self.expChatalyzeShare = info["expChatalyzeShare"].stringValue
        self.transactionFee = info["transactionFee"].stringValue
        self.refundAmount = info["refundAmount"].stringValue
        self.deductFeeFromPlateform = info["refundAmount"].boolValue
        self.transferredToOther = info["transferredToOther"].stringValue
        self.expOtherShare = info["expOtherShare"].stringValue
        self.transferredToOther = info["transferredToOther"].stringValue
        self.expHostShare = info["expHostShare"].stringValue
        self.chargedFee = info["chargedFee"].stringValue
        self.netChatalyzeShare = info["netChatalyzeShare"].stringValue
    }
    
}
