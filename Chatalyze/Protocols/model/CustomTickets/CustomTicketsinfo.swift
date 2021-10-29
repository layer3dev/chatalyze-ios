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
    
    var start : String?
    var end : String?
    var room_id : Int?
    var title: String?
    var hostName : String?
    
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
        
        self.room_id = json["id"].intValue
        self.title = json["title"].stringValue
        self.start = json["start"].stringValue
        self.end = json["end"].stringValue
        self.hostName = json["user"]["firstName"].stringValue
    }
    
}

