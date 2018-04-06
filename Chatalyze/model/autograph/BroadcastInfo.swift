//
//  BroadcastInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class BroadcastInfo : NSObject{
    var x = Double(0)
    var isContinous = false
    var strokeWidth : Int?
    var counter : Int?
    var pressure : Int?
    var strokeColor : String?
    var reset = false
    var erase = false
    var y = Double(0)
    
    
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
        x = json["x"].doubleValue
        isContinous = json["isContinous"].boolValue
        strokeWidth = json["StrokeWidth"].intValue
        counter = json["counter"].intValue
        pressure = json["pressure"].intValue
        strokeColor = json["StrokeColor"].stringValue
        reset = json["reset"].boolValue
        erase = json["Erase"].boolValue
        y = json["y"].doubleValue
        
    }
    
    var point : CGPoint{
        get{
            return CGPoint(x: x, y: y)
        }
    }
}
