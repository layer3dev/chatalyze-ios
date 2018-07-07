//
//  MyTicketsRootView.swift
//  Chatalyze
//
//  Created by Mansa on 22/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class MyTicketsRootView:ExtendedView{

    var controller:MyTicketsController?
    @IBOutlet var adapter:MyTicketesAdapter?

    override func viewDidLayout(){
        super.viewDidLayout()
        
        adapter?.root = self
    }    
    
    func fillInfo(info:[SlotInfo]?){
        
        guard let info = info else {
            return
        }
        adapter?.initailizeAdapter(info:info)
    }
    
    func initializeLayout(){
    }
    
}
