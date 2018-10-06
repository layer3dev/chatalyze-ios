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
    var ticketsArray:[EventSlotInfo] = [EventSlotInfo]()
    var callTimerTest = Timer()
    let eventSlotListiner = TicketSlotListener()
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //fetchInfo()
        paintInterface()
        initializeVariable()
        scroll?.delegate = self
        registerEventSlotListner()       
    }
    
    
    func registerEventSlotListner(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }        
        eventSlotListiner.userId = id
        eventSlotListiner.setListener {
            
            Log.echo(key: "yud", text:"New slot is booked")
            self.fetchInfo()
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
        
        paintHideBackButton()
        paintSettingButton()
    }
    
    func initializeVariable(){
        
        rootview?.controller = self
    }
    
    func refreshData(){
        
        fetchInfo()
    }
    
    func fetchInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        
        self.showLoader()
        CallSlotFetch().fetchInfos() {(success, info) in
            
            self.ticketsArray.removeAll()
           self.rootview?.adapter?.initializeCollectionFlowLayout()
            
            self.rootview?.fillInfo(info: self.ticketsArray)
            self.stopLoader()
            
            if !success{
                
                self.noTicketLbl?.isHidden = false
                return
            }
            
            if let info = info{
                
                if info.count <= 0{
                  
                    self.noTicketLbl?.isHidden = false
                    self.rootview?.fillInfo(info: self.ticketsArray)
                    return
                }
                self.ticketsArray = info
                self.noTicketLbl?.isHidden = true
                self.rootview?.fillInfo(info: info)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

