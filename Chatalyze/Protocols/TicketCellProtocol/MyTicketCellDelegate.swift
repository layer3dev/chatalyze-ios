//
//  MyTicketCellDelegate.swift
//  Chatalyze
//
//  Created by Mansa on 30/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
protocol MyTicketCellDelegate {
    
    func jointEvent(info:SlotInfo?)
    func systemTest()
    func claimTicket(info : PurchaseTicketRequest?)
}


protocol DimissListener{
    func launchCallRoom(result:Bool?)
}
