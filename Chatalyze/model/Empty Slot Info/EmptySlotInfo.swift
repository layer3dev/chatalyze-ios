//
//  EmptySlotInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class EmptySlotInfo:NSObject {
    var index : Int?
    var startDate:Date?
    var endDate:Date?
    var slotInfo:SlotInfo?
    var isSelected = false 

    override init() {
        super.init()
    }
    
    init(startDate:Date?,endDate:Date?, index : Int) {
        super.init()
        
        self.fillInfo(startDate:startDate,endDate:endDate, index: index)
    }
    
    func fillInfo(startDate:Date?,endDate:Date?, index : Int){
        
        guard let startDate = startDate else{
            return
        }
        guard let endDate = endDate else{
            return
        }
        self.startDate = startDate
        self.endDate = endDate
        self.index = index
    }
    
   
}
