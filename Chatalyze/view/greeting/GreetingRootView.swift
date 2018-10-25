//
//  GreetingRootView.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class GreetingRootView:ExtendedView{

    var controller:GreetingController?
    @IBOutlet var greetingTableView:UITableView?
    fileprivate var adapter = GreetingsAdapter()
    
    override func viewDidLayout(){
        super.viewDidLayout()
        adapter.root = self
    }
    
    
    
    func fillInfo(info:[GreetingInfo]?){
        
        guard let info = info else{
            return
        }
        adapter.greetingArray = info
        greetingTableView?.dataSource = adapter
        greetingTableView?.delegate = adapter
        greetingTableView?.reloadData()
    }
    
    func insertPageData(info:GreetingInfo?){
        
        guard let info = info else {
            return
        }
        adapter.greetingArray.append(info)
        self.greetingTableView?.beginUpdates()
        self.greetingTableView?.insertRows(at: [IndexPath(row: adapter.greetingArray.count-1, section: 0)],with:  UITableView.RowAnimation.automatic)
        self.greetingTableView?.endUpdates()
    }
    
    func fetchDataForPagination(){
        controller?.fetchDataForPagination()
    }
}
