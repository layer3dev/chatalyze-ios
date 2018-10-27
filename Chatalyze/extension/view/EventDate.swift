//
//  EventDate.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

public extension Date {
    
    func isPast()->Bool{
        return !isFuture()
    }
    
    func isFuture()->Bool{
             
        let timeInterval = self.timeIntervalSinceNow
        if(timeInterval > 0){
            return true
        }
        return false
    }
}

