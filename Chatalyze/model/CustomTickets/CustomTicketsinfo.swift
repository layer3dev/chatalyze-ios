//
//  CustomTicketsinfo.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON


class CustomTicketsInfo : NSObject{
    
    var meta : CustumTicketsMeta?
    var room_id : String?
    
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
        
        meta = CustumTicketsMeta(info : json["data"])
        self.room_id = json["room_id"].stringValue

    }
    
}


class CustumTicketsMeta: NSObject {
    var endTime : String?
    var startTime : String?
    
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
        endTime = json["end"].stringValue
        startTime = json["start"].stringValue
    }
}

