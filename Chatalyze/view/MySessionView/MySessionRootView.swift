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
    
    func initializeVariable(){
        
        adapter.root = self        
        adapter.enterSession = {(eventInfo) in            
//            guard let controller = SessionController.instance() else{
//                return
//            }
//
//            controller.paintBackButton()
//            controller.paintNavigationTitle(text: "Session")
//
//            self.controller?.navigationController?.pushViewController(controller, animated: true)
            
            guard let eventInfo = eventInfo
                else{
                    return
            }
            
            guard let eventId = eventInfo.id
                else{
                    return
            }
            
            self.isEventDelayed(eventId: "\(eventId)", completion: { (success) in
                
                
                if success{
                  
                    //Success will be true of event is true.
                    guard let controller = HostEventQueueController.instance()
                        else{
                            return
                    }
                    
                    controller.eventId = "\(eventId)"
                    self.controller?.navigationController?.pushViewController(controller, animated: true)
                    return
                    
                }

                if(!eventInfo.isPreconnectEligible && eventInfo.isFuture){
                    
                    guard let controller = HostEventQueueController.instance()
                        else{
                            return
                    }
                    
                    controller.eventId = "\(eventId)"
                    self.controller?.navigationController?.pushViewController(controller, animated: true)
                    return
                }
                
                Log.echo(key: "rotate", text: "Host Call Controllern new instance MySessionRootView")
                
                guard let controller = HostCallController.instance()
                    else{
                        return
                }
                
                controller.eventId = String(eventId)
                self.controller?.present(controller, animated: true, completion: nil)
            })
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
