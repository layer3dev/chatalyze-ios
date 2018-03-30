
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        intialization()
        
    }
    
    
    private func intialization(){
        initializeVariable()
        paintInterface()
        
        testData()
    }
    
    private func paintInterface(){
        paintNavigationBar()
        edgesForExtendedLayout =  [UIRectEdge.bottom]
    }
    
    
    
    private func paintNavigationBar(){
        paintNavigationLogo()
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
        let storyboard = UIStoryboard(name: "call_queue", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "event_queue") as? EventQueueController
        
        return controller
    }
}
