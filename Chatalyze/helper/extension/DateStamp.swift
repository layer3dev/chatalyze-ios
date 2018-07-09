//
//  DateStamp.swift
//  Chatalyze
//
//  Created by Sumant Handa on 17/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

public extension Date {

    var millisecondsSince1970:Int {
        
        //TODO:- Remove this
        return 0
        let interval = Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        return Int(interval)
    }
    
    init(milliseconds:Int){
        
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    init(seconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
}
