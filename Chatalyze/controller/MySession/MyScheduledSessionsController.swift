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
    @IBOutlet var noSessionView:ButtonContainerCorners?
    @IBOutlet var mySessionLbl:UILabel?
    var eventArray:[EventInfo] = [EventInfo]()
    let updatedEventScheduleListner = EventListener()
    let eventDeletedListener = EventDeletedListener()
    let chatCountUpdateListener = UpdateChatCountInSessionsListeners()
    let applicationStateListener = ApplicationStateListener()
    @IBOutlet var chatPupHeightConstraint:NSLayoutConstraint?
    //Past Data fetching Info
    var pastEventsArray = [EventInfo]()
    var isPastEventsFetching = false
    var isFetchingPastEventCompleted = false
    var limit = 8
    enum eventTypes:Int{
        case upcoming = 0
        case past = 1
    }
    var currentEventShowing = eventTypes.upcoming
    @IBOutlet var tableTopConstraint:NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //initializeVariable()
        paintInterface()
        eventListener()
    }
    
    func eventListener(){
        
        applicationStateListener.setForegroundListener {[weak self] in
            self?.fetchInfoForListener()
        }
        
        updatedEventScheduleListner.setListener {
            self.fetchInfoForListener()
        }
        
        eventDeletedListener.setListener {(deletedEventID) in
          
            for info in self.eventArray{
                
                Log.echo(key: "yud", text: "Event id is \(info.id)")
                if info.id == Int(deletedEventID ?? "0"){
                    
                    self.fetchInfoForListener()
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
    
    func showUpcoming(){
        
    }
    
    func updateScrollViewWithTable(height:CGFloat){
    }
    
    func handleScrollingHeader(direction:MySessionAdapter.scrollDirection){
    }
    
    func handleScrollingHeaderOnEndDragging(direction:MySessionAdapter.scrollDirection){
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
        
        if self.currentEventShowing == .past{
            return
        }
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }
        self.showLoader()
        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
         
            self.stopLoader()
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
            self.tableTopConstraint?.constant = -22.0
            self.mySessionLbl?.isHidden = false
            
            if success{
                if let array  = info{
                    if array.count > 0{
                        
                        self.showShareView()
                        self.noeventLbl?.isHidden = true
                        self.mySessionLbl?.isHidden = false
                        self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                        self.tableTopConstraint?.constant = -22.0
                        for info in array{
                            self.eventArray.append(info)
                            self.rootView?.fillInfo(info: self.eventArray)
                        }
                    }else if array.count <= 0{
                        
                        self.hideShareView()
                        self.noeventLbl?.isHidden = false
                        self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
                        self.tableTopConstraint?.constant = 10.0
                        self.mySessionLbl?.isHidden = true
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            
            self.hideShareView()
            self.noeventLbl?.isHidden = false
            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
            self.tableTopConstraint?.constant = 10.0
            self.mySessionLbl?.isHidden = true
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }
    
    func fetchInfoForListener(){
        
        if self.currentEventShowing == .past{
            return
        } 
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }

        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
            
            self.eventArray.removeAll()
            self.noeventLbl?.isHidden = true
            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
            self.tableTopConstraint?.constant = -22.0
            self.mySessionLbl?.isHidden = false

            if success{
                if let array  = info{
                    if array.count > 0{
                        
                        self.showShareView()
                        self.noeventLbl?.isHidden = true
                        self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                        self.tableTopConstraint?.constant = -22.0
                        self.mySessionLbl?.isHidden = false

                        for info in array{
                            self.eventArray.append(info)
                            self.rootView?.fillInfo(info: self.eventArray)
                        }
                    }else if array.count <= 0{
                       
                        self.hideShareView()
                        self.noeventLbl?.isHidden = false
                        self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
                        self.tableTopConstraint?.constant = 10.0
                        self.mySessionLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.eventArray)
                    }
                    return
                }
            }
            self.hideShareView()
            self.noeventLbl?.isHidden = false
            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
            self.tableTopConstraint?.constant = 10.0
            self.mySessionLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.eventArray)
            return
        }
    }
    
    func FetchEventsForPastForPagination(){
        
        if currentEventShowing == .upcoming{
            return
        }
        if isPastEventsFetching{
            return
        }
        if isFetchingPastEventCompleted{
            return
        }
        self.isPastEventsFetching = true
        FetchPastEventsProcessor().fetch(offset: self.pastEventsArray.count) { (success, message, info) in
            
            // Log.echo(key: "yud", text: "past events counts are \(info?.count)")
            DispatchQueue.main.async {
                
                self.isPastEventsFetching = false
                if success{
                    if let array = info {
                        if array.count >= self.limit {
                            
                            for info in array{
                                self.pastEventsArray.append(info)
                                self.rootView?.fillInfo(info: self.pastEventsArray)
                            }
                        }else if array.count < self.limit {
                            
                            self.isFetchingPastEventCompleted = true
                            self.rootView?.fillInfo(info: self.pastEventsArray)
                        }
                        return
                    }
                }
                self.rootView?.fillInfo(info: self.pastEventsArray)
                return
            }
        }
    }
    
    
    func FetchEventsForPast(){
        
        if currentEventShowing == .upcoming{
            return
        }
        
        if isPastEventsFetching{
            return
        }
        if isFetchingPastEventCompleted{
            return
        }
        self.isPastEventsFetching = true
        self.showLoader()
        FetchPastEventsProcessor().fetch(offset: self.pastEventsArray.count) { (success, message, info) in
            
            // Log.echo(key: "yud", text: "past events counts are \(info?.count)")
            DispatchQueue.main.async {
                
                self.stopLoader()
                self.isPastEventsFetching = false
                if success{
                    if let array = info {
                        if array.count >= self.limit {
                            
                            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                            self.tableTopConstraint?.constant = -22.0
                            for info in array{
                                self.pastEventsArray.append(info)
                                self.rootView?.fillInfo(info: self.pastEventsArray)
                            }
                        }else if array.count < self.limit {
                            
                            self.isFetchingPastEventCompleted = true
                            self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
                            self.tableTopConstraint?.constant = 10.0
                            self.rootView?.fillInfo(info: self.pastEventsArray)
                        }
                        return
                    }
                }
                self.chatPupHeightConstraint?.priority = UILayoutPriority(rawValue: 250.0)
                self.tableTopConstraint?.constant = 10.0
                self.rootView?.fillInfo(info: self.pastEventsArray)
                return
            }
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
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        applicationStateListener.releaseListener()
    }
    
    class func instance()->MyScheduledSessionsController?{
        
        let storyboard = UIStoryboard(name: "MySessions", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyScheduledSessions") as? MyScheduledSessionsController
        return controller
    }
}

extension MyScheduledSessionsController{
}

