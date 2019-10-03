//
//  CanvasInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class CanvasInfo : NSObject{
    
    var width : Double?
    var height : Double?
    var screenshot : ScreenshotInfo?
    var currentSlotId :Int?
    
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
        screenshot = ScreenshotInfo(info : json["screenshot"])
        width = json["width"].doubleValue
        height = json["height"].doubleValue
        self.currentSlotId = Int(json["forSlotId"].stringValue)
    }
}
