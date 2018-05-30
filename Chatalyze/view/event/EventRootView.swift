//
//  EventRootView.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EventRootView:ExtendedView {
    
    var controller:EventController?
    @IBOutlet var eventTable:UITableView?
    fileprivate var adapter:EventAdapter?
    var eventArray = [EventInfo]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
    }
    
    func paintInterface(){
    }
    
    func initializeVariable(){
        
        adapter = EventAdapter()
        adapter?.root = self
        eventTable?.dataSource = adapter
        eventTable?.delegate = adapter
        eventTable?.reloadData()
    }
    func fillInfo(info:[EventInfo]?){
        
        guard let array = info else {
            return
        }
        self.eventArray.removeAll()
        for info in array{
            self.eventArray.append(info)
        }
        adapter?.eventArray = self.eventArray
        self.eventTable?.reloadData()
    }
}
