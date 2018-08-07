//
//  SlotTimeInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 06/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class SlotTimeInfo: SlotFlagInfo {
    var _start : String?
    var startDate : Date?
    var endDate : Date?
    var _end : String?
    
    var isBreak = false
    
    init(info : JSON?){
        super.init()
        
        fillRawInfo(info: info)
    }
    
    private func fillRawInfo(info : JSON?) {
        
        guard let json = info
            else{
                return
        }
        start = json["start"].string
        end = json["end"].string
    }
    
    var start : String?{
        get{
            return _start
        }
        set{
            _start = newValue
            guard let startLocal = _start
                else{
                    return
            }
            startDate = DateParser.UTCStringToDate(startLocal)
        }
    }
    
    var end : String?{
        
        get{
            return _end
        }
        set{
            _end = newValue
            guard let endLocal = _end
                else{
                    return
            }
            endDate = DateParser.UTCStringToDate(endLocal)
        }
    }
}
