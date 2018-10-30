
//
//  EventQueueController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 30/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventQueueController: InterfaceExtendedController {
    
    @IBOutlet fileprivate var collectionView : UICollectionView?
    fileprivate var adapter : EventQueueAdapter?
    var eventId : String? //Expected param
    var eventInfo : EventScheduleInfo?
    var timer : EventTimer = EventTimer()
    private let eventSlotListener = EventSlotListener()
    @IBOutlet var bottomLine:UIView?

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        intialization()
        
    }
    
    var rootView : CallQueueRootView?{
        get{
            guard let root = self.view as? CallQueueRootView
                else{
                return nil
            }
            return root
        }
    }
        
    private func intialization(){
 
        initializeVariable()
        paintInterface()
        registerForEvent()
        registerForTimer()
        loadInfoFromServer(showLoader : true)
        listenOnSocketConnect()
    }
    func listenOnSocketConnect(){
        
        UserSocket.sharedInstance?.socket?.on("connect") {data, ack in
            
            Log.echo(key: "yud", text:"socket connected , the data is connect ==>\(data) and the acknowledgment is \(ack.expected)")
            DispatchQueue.main.async {
                
                self.loadInfoFromServer(showLoader : true)
            }
        }
    }
    
    
    func loadInfoFromServer(showLoader : Bool){
      
        fetchInfo(showLoader: showLoader) { [weak self] (success) in
            if(!success){
                return
            }
            self?.processEventInfo()
        }
    }

    
    override func viewDidRelease() {
        super.viewDidRelease()
      
        timer.pauseTimer()
        eventSlotListener.setListener(listener: nil)
        
        
    }
    
    
    
    private func registerForTimer(){
        
        timer.startTimer()
        timer.ping { [weak self] in
            self?.refresh()
        }
    }
    
    private func registerForEvent(){
        
        eventSlotListener.setListener { [weak self] in
            self?.loadInfoFromServer(showLoader : false)
        }
    }
    
    func refresh(){
    }
    
    func processEventInfo(){
        
        hideBottomLine()
        rootView?.eventInfo = self.eventInfo
        guard let slotInfos = self.eventInfo?.slotInfos
            else{
                return
        }
        if slotInfos.count > 0 {
            showBottomLine()
        }
        self.adapter?.infos = slotInfos
        self.collectionView?.reloadData()
    }
    func hideBottomLine(){
        
        bottomLine?.isHidden = true
    }
    
    func showBottomLine(){
        
        bottomLine?.isHidden = false
    }   
    
    private func paintInterface(){
      
        paintSettingButton()
        paintNavigationBar()
        //edgesForExtendedLayout =  [UIRectEdge.bottom]
    }
        
    private func paintNavigationBar(){
        
        paintNavigationTitle(text: "Event")
        paintBackButton()
    }
    
    private func initializeVariable(){
        
        if let eventId = self.eventId{
            eventSlotListener.eventId = eventId
        }
        adapter = EventQueueAdapter()
        collectionView?.delegate = adapter
        collectionView?.dataSource = adapter
        collectionView?.collectionViewLayout = EventQueueFlowLayout()
    }
    
    
    private func testData(){
    
        var infos = [SlotInfo]()
        for i in 0 ... 10{
            let info = SlotInfo(info : nil)
            info.slotNo = i
            infos.append(info)
        }
        self.adapter?.infos = infos
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func verifyEventActivated(){        
    }

}

extension EventQueueController{
    
    class func instance()->EventQueueController?{
        
        guard let role = SignedUserInfo.sharedInstance?.role
            else{
                return nil
        }
        let storyboard = UIStoryboard(name: "call_queue", bundle: nil)
        var controllerName = "user_event_queue"
        controllerName = role == .analyst ? "host_event_queue" : "user_event_queue"
        let controller = storyboard.instantiateViewController(withIdentifier: controllerName) as? EventQueueController        
        return controller
    }
}

//instance
extension EventQueueController{
    
    fileprivate func fetchInfo(showLoader : Bool, completion : ((_ success : Bool)->())?){
        guard let eventId = self.eventId
            else{
                return
        }
        
        if(showLoader){
            self.showLoader()
        }
        
        CallEventInfo().fetchInfo(eventId: eventId) { [weak self] (success, info) in
          
            if(showLoader){
            
                self?.stopLoader()
            }
           
            if(!success){
            
                completion?(false)
                return
            }
            
            guard let localEventInfo = info
                else{
                    completion?(false)
                    return
            }
            
            self?.eventInfo = localEventInfo
            let roomId = localEventInfo.id ?? 0
            Log.echo(key : "service", text : "eventId - > \(roomId)")
            self?.verifyEventActivated()
            completion?(true)
            return
        }
    }
    
}


