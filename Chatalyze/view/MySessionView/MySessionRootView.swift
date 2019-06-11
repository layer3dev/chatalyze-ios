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
        
        initializeVariable()
    }

    
    func paintNewUI(){
        //to be override
    }
    func initializeVariable(){
        
        adapter.root = self        
        adapter.enterSession = {(eventInfo) in            
            
            guard let eventInfo = eventInfo
                else{
                    //Case less than 30 minute
                    self.controller?.fetchInfoForListener()
                    return
            }
            
            guard let eventId = eventInfo.id
                else{
                    return
            }
            
            guard let controller = HostCallController.instance()
                else{
                    return
            }
            controller.eventId = String(eventId)
            self.controller?.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func isEventDelayed(eventId:String?,completion:@escaping ((Bool)->())){
        
        guard let id = eventId else{
            completion(true)
            return
        }
        self.controller?.showLoader()
        CallEventInfo().fetchInfo(eventId: id) { (success, eventInfo) in
            self.controller?.stopLoader()
            if !success{
                completion(true)
                return
            }
            guard let info = eventInfo else{
                completion(true)
                return
            }
            if info.notified == "delayed"{
                completion(true)
                return
            }
            completion(false)
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
