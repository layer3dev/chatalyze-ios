//
//  MySessionRootView.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


class MySessionRootView:ExtendedView{
    
    let adapter = MySessionAdapter()
    var controller:MyScheduledSessionsController?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initializeVariiable()
    }
    
    func initializeVariiable(){
        
        adapter.enterSession = {
            
            guard let controller = SessionController.instance() else{
                return
            }
            controller.paintBackButton()
            controller.paintNavigationTitle(text: "Session")
            self.controller?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func initializeAdapter(table:UITableView?){
        
        adapter.initializeAdapter(table: table)
    }
    
    func fillInfo(info: [EventInfo]?){
        
        guard let info = info else{
            return
        }
        adapter.updatedInfo(info:info)
    }
}
