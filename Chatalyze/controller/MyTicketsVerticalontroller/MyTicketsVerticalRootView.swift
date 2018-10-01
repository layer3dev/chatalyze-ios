//
//  MyTicketsVerticalRootView.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsVerticalRootView:MyTicketsRootView {
    
    @IBOutlet var tableAdapter:MyTicketesVerticalAdapter?
    var table:UITableView?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        tableAdapter?.root = self
        tableAdapter?.myTicketsVerticalTableView = self.table
    }
    
    override func fillInfo(info:[EventSlotInfo]?){
        
        guard let info = info else {
            return
        }
        tableAdapter?.initailizeAdapter(info:info)
    }
}
