//
//  TwillioTokenInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 01/11/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class TwillioTokenInfo: NSObject {
    
    var time:Int?
    var room:String?
    var identity:String?
    var token:String?
    
    init(info:JSON?) {
        super.init()

        self.fillInfo(info: info)
    }
    
    func fillInfo(info:JSON?){

        guard let data = info else{
            return
        }
        
        self.time = data["time"].intValue
        self.room = data["room"].stringValue
        self.identity = data["identity"].stringValue
        self.token = data["token"].stringValue
    }
}
