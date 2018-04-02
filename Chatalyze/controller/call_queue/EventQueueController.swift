
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
        registerForTimer()
        
        
        fetchInfo { [weak self] (success) in
            if(!success){
                return
            }
            self?.processEventInfo()
        }
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        timer.pauseTimer()
    }
    
    private func registerForTimer(){
        timer.startTimer()
        timer.ping { [weak self] in
            self?.refresh()
        }
    }
    
    func refresh(){
        
    }
    
    func processEventInfo(){
        
        rootView?.eventInfo = self.eventInfo
        guard let slotInfos = self.eventInfo?.slotInfos
            else{
                return
        }
        
        self.adapter?.infos = slotInfos
        self.collectionView?.reloadData()
        
    }
    
    private func paintInterface(){
        paintNavigationBar()
        edgesForExtendedLayout =  [UIRectEdge.bottom]
    }
    
    
    
    private func paintNavigationBar(){
        paintNavigationTitle(text: "Event")
        paintBackButton()
    }
    
    
    private func initializeVariable(){
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
    
    fileprivate func fetchInfo(completion : ((_ success : Bool)->())?){
        guard let eventId = self.eventId
            else{
                return
        }
        
        self.showLoader()
        CallEventInfo().fetchInfo(eventId: eventId) { [weak self] (success, info) in
            
            self?.stopLoader()
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
            
            completion?(true)
            return
            
        }
    }
}