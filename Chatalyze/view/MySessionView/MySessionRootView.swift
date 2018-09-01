//
//  MySessionRootView.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


class MySessionRootView:ExtendedView{
    
    let adapter = MySessionAdapter()
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    
    func initializeAdapter(table:UITableView?){
        adapter
    }
    
    func updateAdapter(info:[MySessionsInfo]?){
        
    }
    

}
