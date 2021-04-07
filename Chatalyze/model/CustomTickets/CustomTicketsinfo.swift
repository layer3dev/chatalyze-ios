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
    
    var startTime : String?
    var room_id : String?
    var title: String?
    
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
        
       
        self.room_id = json["room_id"].stringValue
        self.title = json["title"].stringValue
        startTime = json["start"].stringValue
        
    }
    
}


class CustumTicketsMeta: NSObject {
    var endTime : String?
    
    
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
        
    }
}

