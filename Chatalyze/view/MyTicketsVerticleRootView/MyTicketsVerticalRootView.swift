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
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        tableAdapter?.root = self
    }
    
    
    override func fillInfo(info:[EventSlotInfo]?){
        
        DispatchQueue.main.async {
         
            Log.echo(key: "yud", text: "Override fill info is calling")
            guard let info = info else {
                return
            }
            self.tableAdapter?.initailizeAdapter(info:info)
        }
    }
}
