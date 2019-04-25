//
//  MyTicketsController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

protocol getTicketsScrollInsets {
    
    func getTicketsScrollInset(scrollView:UIScrollView)
}

import UIKit

class MyTicketsController: InterfaceExtendedController{
    
    var delegate:getTicketsScrollInsets?
    var featureHeight:CGFloat = 0.0
    @IBOutlet var rootview:MyTicketsRootView?
    @IBOutlet var scroll:UIScrollView?
    @IBOutlet var noTicketLbl:UILabel?
    @IBOutlet var noTicketView:UIView?
    var ticketsArray:[EventSlotInfo] = [EventSlotInfo]()
    var callTimerTest = Timer()
    let eventSlotListiner = TicketSlotListener()
    let applicationStateListener = ApplicationStateListener()
   
    @IBOutlet var topOfHeaderConstraint:NSLayoutConstraint?

    //Past Data fetching Info
    var pastSlotsArray = [EventSlotInfo]()
    var isPastEventsFetching = false
    var isFetchingPastEventCompleted = false
    var limit = 8
    enum eventTypes:Int{
        case upcoming = 0
        case past = 1
    }
    var currentEventShowing = eventTypes.upcoming
    @IBOutlet var upcomingLabel:UILabel?
    @IBOutlet var pastLabel:UILabel?
    @IBOutlet var upcomingBorder:UIView?
    @IBOutlet var pastBorder:UIView?
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //fetchInfo()
        paintInterface()
        initializeVariable()
        scroll?.delegate = self
        registerEventSlotListner()       
    }
    
    
    @IBAction func showPastEvents(sender:UIButton?){
        
        currentEventShowing = .past
        resetUpcomingData()
        fetchPreviousTicketsInfo()
    }
    
    @IBAction func showUpcomingEvents(sender:UIButton?){
        
        currentEventShowing = .upcoming
        resetPastData()
        fetchInfo()
    }
    
    func resetPastData(){
        
        self.upcomingLabel?.textColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
        self.upcomingBorder?.backgroundColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
        
        
        self.pastLabel?.textColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        self.pastBorder?.backgroundColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        
        self.pastSlotsArray.removeAll()
        self.rootview?.fillInfo(info: self.pastSlotsArray)
        isPastEventsFetching = false
        isFetchingPastEventCompleted = false
    }
    
    func resetUpcomingData(){
        
        self.upcomingLabel?.textColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        self.upcomingBorder?.backgroundColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        
        
        self.pastLabel?.textColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
        self.pastBorder?.backgroundColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
       
        self.ticketsArray.removeAll()
        self.rootview?.fillInfo(info: self.ticketsArray)
    }

    
    func registerEventSlotListner(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        eventSlotListiner.userId = id
        eventSlotListiner.setListener {
            self.fetchInfoForListenr()
        }
        
        applicationStateListener.setForegroundListener {[weak self] in
            self?.fetchInfoForListenr()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "My Tickets")
        initializeVariable()
        //paintInterface()
        registerEventSlotListner()
        fetchInfo()
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.rootview?.initializeLayout()
    }
    
    func paintInterface(){
        
        //paintBackButton()
        //paintHideBackButton()
        paintSettingButton()
    }
    
    func initializeVariable(){
        
        rootview?.controller = self
    }
    
    func refreshData(){
        fetchInfo()
    }
    
    func fetchInfoForListenr(){
     
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
      
        CallSlotFetch().fetchInfos() {(success, info) in
            
            DispatchQueue.main.async {
                
                self.ticketsArray.removeAll()
                self.rootview?.adapter?.initializeCollectionFlowLayout()
                
                self.rootview?.fillInfo(info: self.ticketsArray)
                
                if !success{
                    
                    self.noTicketLbl?.isHidden = false
                    self.noTicketView?.isHidden = false
                    return
                }
                
                if let info = info{
                    
                    if info.count <= 0{
                        
                        self.noTicketLbl?.isHidden = false
                        self.noTicketView?.isHidden = false
                        self.rootview?.fillInfo(info: self.ticketsArray)
                        return
                    }
                    self.ticketsArray = info
                    self.noTicketLbl?.isHidden = true
                    self.noTicketView?.isHidden = true
                    self.rootview?.fillInfo(info: info)
                }
            }
        }
    }
    
    
    func fetchInfo(){
        
        if self.currentEventShowing == .past{
            return
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        CallSlotFetch().fetchInfos() {(success, info) in
            
            DispatchQueue.main.async {
                
                self.ticketsArray.removeAll()
                self.rootview?.adapter?.initializeCollectionFlowLayout()
                
                self.rootview?.fillInfo(info: self.ticketsArray)
                self.stopLoader()
                
                if !success{
                    
                    self.noTicketLbl?.isHidden = false
                    self.noTicketView?.isHidden = false
                    return
                }
                
                if let info = info{
                    
                    if info.count <= 0{
                        
                        self.noTicketLbl?.isHidden = false
                        self.noTicketView?.isHidden = false
                        self.rootview?.fillInfo(info: self.ticketsArray)
                        return
                    }
                    self.ticketsArray = info
                    self.noTicketLbl?.isHidden = true
                    self.noTicketView?.isHidden = true
                    self.rootview?.fillInfo(info: info)
                }
            }
        }
    }
    
    func fetchPreviousTicketsInfo(){
        
        if self.currentEventShowing == .upcoming {
            return
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        FetchOldTicketsProcessor().fetchInfos(offset:0,limit: self.limit, completion: {(success, info) in
            self.stopLoader()
        
            DispatchQueue.main.async {
        
                self.pastSlotsArray.removeAll()
                self.rootview?.adapter?.initializeCollectionFlowLayout()
                self.rootview?.fillInfo(info: self.pastSlotsArray)
                self.stopLoader()
                
                if !success{
                    
                    self.noTicketLbl?.isHidden = false
                    self.noTicketView?.isHidden = false
                    return
                }
                
                if let info = info{
                    
                    if info.count <= 0{
                        
                        self.noTicketLbl?.isHidden = false
                        self.noTicketView?.isHidden = false
                        self.rootview?.fillInfo(info: self.pastSlotsArray)
                        return
                    }
                    self.pastSlotsArray = info
                    self.noTicketLbl?.isHidden = true
                    self.noTicketView?.isHidden = true
                    self.rootview?.fillInfo(info: info)
                }
            }
        })
    }
    
    func fetchPreviousTicketsInfoForPagination(){
        
        Log.echo(key: "yud", text: "calling is failed")

        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        if currentEventShowing == .upcoming {
            return
        }
        
        if isPastEventsFetching {
            return
        }
        
        if isFetchingPastEventCompleted {
            return
        }
        
        self.isPastEventsFetching = true
        
        Log.echo(key: "yud", text: "calling is passed")
        
        FetchOldTicketsProcessor().fetchInfos(offset:self.pastSlotsArray.count,limit: self.limit, completion: {(success, info) in
            
            DispatchQueue.main.async {
                
                self.isPastEventsFetching = false
                if success{
                    if let array = info {
                        if array.count >= self.limit {
                            
                            for info in array{
                                self.pastSlotsArray.append(info)
                                self.rootview?.fillInfo(info: self.pastSlotsArray)
                            }
                        }else if array.count < self.limit {
                            
                            self.isFetchingPastEventCompleted = true
                            self.rootview?.fillInfo(info: self.pastSlotsArray)
                        }
                        return
                    }
                }
                self.isFetchingPastEventCompleted = true
                self.rootview?.fillInfo(info: self.pastSlotsArray)
                return
            }
        })
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        applicationStateListener.releaseListener()
    }
    
    class func instance()->MyTicketsController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTickets") as? MyTicketsController
        return controller
    }
}

extension MyTicketsController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.getTicketsScrollInset(scrollView: scrollView)
    }
}

