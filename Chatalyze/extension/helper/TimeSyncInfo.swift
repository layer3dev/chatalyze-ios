//
//  TimeSyncInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 17/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON

class TimeSyncInfo{

    var timestamp : Int = 0
    var identifier : Int = 0
    
    
    init(){
    }
    
    
    init(info : JSON?){
        fillInfo(info: info)
    }
    
    
    func fillInfo(info : JSON?){
        
        guard let info = info?.dictionary
            else{
                return
        }
        
        timestamp = info["timestamp"]?.intValue ?? 0
        identifier = info["requestIdentifier"]?.intValue ?? 0

    }
    
    func isValid()->Bool{
        if(timestamp == 0 || identifier == 0){
            return false
        }
        return true
    }
    
}


