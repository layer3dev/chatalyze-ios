//
//  HostDefaultScreenshot.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class HostDefaultScreenshot : NSObject{
   
    var id : Int?
    var userId : Int?
    var url : String?
    var type : String?
    var createdAt : String?
    var updatedAt : String?
    
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
        
        id = json["id"].int
        userId = json["userId"].int
        url = json["url"].string
        type = json["type"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
    }
    
    func screenshotInfo()->ScreenshotInfo?{
        
        let info = ScreenshotInfo()
        info.id = self.id
        info.analystId = self.userId
        info.screenshot = self.url
        return info
    }
    
}
