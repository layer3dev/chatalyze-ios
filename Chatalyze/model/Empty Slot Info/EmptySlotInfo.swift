//
//  EmptySlotInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class EmptySlotInfo:NSObject {

    var startDate:Date?
    var endDate:Date?
    var slotInfo:SlotInfo?

    override init() {
        super.init()
    }
    
    init(startDate:Date?,endDate:Date?) {
        super.init()
        
        self.fillInfo(startDate:startDate,endDate:endDate)
    }
    
    func fillInfo(startDate:Date?,endDate:Date?){
        
        guard let startDate = startDate else{
            return
        }
        guard let endDate = endDate else{
            return
        }
        self.startDate = startDate
        self.endDate = endDate
    }
}
