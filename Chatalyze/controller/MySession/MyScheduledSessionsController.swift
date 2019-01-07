//
//  MyScheduledSessionsController.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyScheduledSessionsController: InterfaceExtendedController {

    @IBOutlet var sessionListingTableView:UITableView?
    @IBOutlet var noeventLbl:UILabel?
    var eventArray:[EventInfo] = [EventInfo]()
    let updatedEventScheduleListner = EventListener()
    let eventDeletedListener = EventDeletedListener()
    let chatCountUpdateListener = UpdateChatCountInSessionsListeners()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //initializeVariable()
        paintInterface()
        eventListener()
    }
    
    func eventListener(){
        
        updatedEventScheduleListner.setListener {
            self.fetchInfoForListener()
        }
        
        eventDeletedListener.setListener {(deletedEventID) in
          
            for info in self.eventArray{
                
                Log.echo(key: "yud", text: "Event id is \(info.id)")
                if info.id == Int(deletedEventID ?? "0"){
                    Log.echo(key: "yud", text: "Matched Event Id is \(deletedEventID)")
                }
            }
        }
        
        chatCountUpdateListener.setListener{(callScheduleId) in
            
            for info in self.eventArray{
                
                Log.echo(key: "yud", text: "Event id is \(info.id)")
                if info.id == (callScheduleId ?? 0){
                    
                    self.fetchInfoForListener()
                    Log.echo(key: "yud", text: "matched call ScheduleId  Event Id is \(callScheduleId)")
                }
            }
        }        
    }
    
    
    func initializeVariable(){        
        
        rootView?.controller = self        
        fetchInfo()
        rootView?.initializeAdapter(table:self.sessionListingTableView)
    }
    
    func updateScrollViewWithTable(height:CGFloat){
        
        Log.echo(key: "yud", text: "The height of the table is calling in inherited class \(height)")
    }
    
    func paintInterface(){
        
        paintSettingButton()
        paintHideBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "My Sessions")
        initializeVariable()
        //paintInterface()
    }
    
    func fetchInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }
        self.showLoader()
        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
         
            self.stopLoader()
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            if success{
                if let array  = info{
                    if array.count > 0{
                        self.showShareView()
                        self.noeventLbl?.isHidden = true
                        for info in array{
                            self.eventArray.append(info)
                            self.rootView?.fillInfo(info: self.eventArray)
                        }
                    }else if array.count <= 0{
                        self.hideShareView()
                        self.noeventLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            self.hideShareView()
            self.noeventLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }
    
    func fetchInfoForListener(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }

        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
            
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            if success{
                if let array  = info{
                    if array.count > 0{
                        self.showShareView()
                        self.noeventLbl?.isHidden = true
                        for info in array{
                            self.eventArray.append(info)
                            self.rootView?.fillInfo(info: self.eventArray)
                        }
                    }else if array.count <= 0{
                        self.hideShareView()
                        self.noeventLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            self.hideShareView()
            self.noeventLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }
    
    var rootView:MySessionRootView?{
        
        get{
            return self.view as? MySessionRootView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated.
    }
    
    func showShareView(){
    }
    
    func hideShareView(){
    }
    
    class func instance()->MyScheduledSessionsController?{
        
        let storyboard = UIStoryboard(name: "MySessions", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyScheduledSessions") as? MyScheduledSessionsController
        return controller
    }
}

extension MyScheduledSessionsController{
}

