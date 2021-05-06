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
    @IBOutlet var rootview:MyTicketsVerticalRootView?
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
        case custom = 2
    }
    var currentEventShowing = eventTypes.upcoming
    @IBOutlet var upcomingLabel:UILabel?
    @IBOutlet var pastLabel:UILabel?
    @IBOutlet var claimTicketLabel:UILabel?
    
    @IBOutlet var upcomingBorder:UIView?
    @IBOutlet var pastBorder:UIView?
    @IBOutlet var claimTicketBorder : UIView?
    
    
    var isFetchingCustomEventCompleted = false
    var isCustomEventsFetching = false
    var customTicketsArray = [CustomTicketsInfo]()
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //fetchInfo()
        paintInterface()
        initializeVariable()
        scroll?.delegate = self
        registerEventSlotListner()       
    }
    
    
    @IBAction func showPastEvents(sender:UIButton?){
        
        highlightSelectedTab(with: pastBorder, tabLbl: pastLabel)
        
        currentEventShowing = .past
        
        resetUpcomingData()
        resetCustomTicketData()
        
        fetchPreviousTicketsInfo()
    }
    
    @IBAction func showUpcomingEvents(sender:UIButton?){
    
        highlightSelectedTab(with: upcomingBorder, tabLbl: upcomingLabel)
        
        currentEventShowing = .upcoming
        
        resetPastData()
        resetCustomTicketData()
        
        fetchInfo()
    }
    
    
    @IBAction func showClaim(_ sender: Any) {
   
        highlightSelectedTab(with: claimTicketBorder, tabLbl: claimTicketLabel)
        
        currentEventShowing = .custom
        
        resetPastData()
        resetUpcomingData()
        
        fetchCustomTickets()
    }
    
    
    func highlightSelectedTab(with tabBorder:UIView?,tabLbl:UILabel?){
        tabLbl?.textColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
        tabBorder?.backgroundColor = UIColor(red: 250.0/225.0, green: 165.0/255.0, blue: 121.0/255.0, alpha: 1)
    }
    
    func resetPastData(){
        
    
        self.pastLabel?.textColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        self.pastBorder?.backgroundColor = UIColor.clear
        
        self.pastSlotsArray.removeAll()
        self.rootview?.fillInfo(info: self.pastSlotsArray)
        
        isPastEventsFetching = false
        isFetchingPastEventCompleted = false
    }
    
    func resetUpcomingData(){
        
        self.upcomingLabel?.textColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        self.upcomingBorder?.backgroundColor = UIColor.clear
    
        self.ticketsArray.removeAll()
        self.rootview?.fillInfo(info: self.ticketsArray)
    }

    func resetCustomTicketData(){
        
        self.claimTicketLabel?.textColor = UIColor(red: 140.0/255.0, green: 149.0/255.0, blue: 151.0/255.0, alpha: 1)
        self.claimTicketBorder?.backgroundColor = UIColor.clear
    
        
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
        
        paintNavigationTitle(text: "My Tickets".localized())
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
     
        if self.currentEventShowing == .past{
            return
        }
        
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
                    return
                }
                self.noTicketLbl?.isHidden = false
                self.noTicketView?.isHidden = false
                return
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
                
                if !success {
                    
                    self.noTicketLbl?.isHidden = false
                    self.noTicketView?.isHidden = false
                    return
                }
                
                if let info = info {
                    
                    if info.count <= 0 {
                        
                        self.noTicketLbl?.isHidden = false
                        self.noTicketView?.isHidden = false
                        self.rootview?.fillInfo(info: self.pastSlotsArray)
                        return
                    }
                    self.pastSlotsArray = info
                    self.noTicketLbl?.isHidden = true
                    self.noTicketView?.isHidden = true
                    self.rootview?.fillInfo(info: info)
                    return
                }
                self.noTicketLbl?.isHidden = false
                self.noTicketView?.isHidden = false
                return
            }
        })
    }
    
    func fetchCustomTickets(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        
        CustomTicketsHandler().fetchInfo(with: id, offset: 0) {(success, info) in
            self.stopLoader()
        
            DispatchQueue.main.async {
        
                self.customTicketsArray.removeAll()
                self.rootview?.adapter?.initializeCollectionFlowLayout()
                self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                self.stopLoader()
                
                if !success {
                    
                    self.noTicketLbl?.isHidden = false
                    self.noTicketView?.isHidden = false
                    return
                }
                
                if let info = info {
                    
                    if info.count <= 0 {
                        
                        self.noTicketLbl?.isHidden = false
                        self.noTicketView?.isHidden = false
                        self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                        return
                    }
                    self.customTicketsArray = info
                    self.noTicketLbl?.isHidden = true
                    self.noTicketView?.isHidden = true
                    self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                    return
                }
                self.noTicketLbl?.isHidden = false
                self.noTicketView?.isHidden = false
                return
            }
        }
    }
    
    
    func fetchCustomTicketsInfoForPagination(){
        
        Log.echo(key: "yud", text: "calling is failed")

        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        if currentEventShowing == .upcoming {
            return
        }
        
        if isCustomEventsFetching {
            return
        }
        
        if isFetchingCustomEventCompleted {
            return
        }
        
        self.isCustomEventsFetching = true
        
        Log.echo(key: "yud", text: "calling is passed")
        
        CustomTicketsHandler().fetchInfo(with: id, offset: self.customTicketsArray.count) {(success, info) in
            
            
            DispatchQueue.main.async {
                
                self.isCustomEventsFetching = false
                if success{
                    if let array = info {
                        if array.count >= self.limit {
                            
                            for info in array{
                                self.customTicketsArray.append(info)
                                self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                            }
                        }else if array.count < 8 {
                            
                            self.isFetchingCustomEventCompleted = true
                            self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                        }
                        return
                    }
                }
                self.isFetchingCustomEventCompleted = true
                self.rootview?.fillCustomTicketsInfo(info: self.customTicketsArray)
                return
            }
            
        }
        
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

