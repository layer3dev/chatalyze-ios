//
//  MyTicketesAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 22/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

//Obsolete
class MyTicketesAdapter: ExtendedView {
    
    @IBOutlet var myTicketsCollectionView:UICollectionView?
    var layout = UICollectionViewFlowLayout()
    var root:MyTicketsRootView?
    var ticketsListingArray = [EventSlotInfo]()
    var featureHeight:CGFloat = 0.0
    var myTicketsVerticalTableView:UITableView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //initializeCollectionFlowLayout()
    }
    
    func initailizeAdapter(info:[EventSlotInfo]?){
        
        guard let info = info else {
            return
        }
        ticketsListingArray = info
        //initializeCollectionFlowLayout()
        myTicketsCollectionView?.dataSource = self
        myTicketsCollectionView?.delegate = self
        myTicketsCollectionView?.reloadData()
    }
    
    func initializeCollectionFlowLayout(){
        
        //self.myTicketsCollectionView?.layoutIfNeeded()
        let width = root?.superview?.frame.size.width ?? 60.0
        let height:CGFloat = self.myTicketsCollectionView?.bounds.height ?? 0.0
        Log.echo(key: "yud", text: "The height of the Collection is \(height)")
        if width <= 60.0 || height <= 15.0{
            return
        }
        
        layout.itemSize = CGSize(width: width-60, height: height-15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 0)
        //layout.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        myTicketsCollectionView?.collectionViewLayout = layout
        myTicketsCollectionView?.alwaysBounceVertical = false
        self.myTicketsCollectionView?.dataSource = self
        self.myTicketsCollectionView?.delegate = self
    }    
}

extension MyTicketesAdapter:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return ticketsListingArray.count
        //return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = myTicketsCollectionView?.dequeueReusableCell(withReuseIdentifier: "MyTicketsCell", for: indexPath) as? MyTicketsCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        if indexPath.row >= ticketsListingArray.count{
            return UICollectionViewCell()
        }
        cell.fillInfo(info: ticketsListingArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.ticketsListingArray.count-1{
            if root?.controller?.currentEventShowing == .past {
                
                Log.echo(key: "yud", text: "Fetching the past events from will display indexpath is \(indexPath.row) and the listing array count is \(self.ticketsListingArray.count)")
                // FetchEventsForPastForPagination automatically denied if the events are fetched completely
                root?.controller?.fetchPreviousTicketsInfoForPagination()
            }
            //ask for more cells
        }
        //
    }
}

extension MyTicketesAdapter:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


extension MyTicketesAdapter:MyTicketCellDelegate{
    
    //    private func verifyForEventDelay(){
    //
    //        guard let slotInfo = slotInfo else{
    //            return
    //        }
    //
    //Verifying that event is delayed or not started yet
    
    //    if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "" ) == ""){
    //
    //            showAlertMessage()
    //            statusLbl?.text = "Session has not started yet."
    //            return
    //        }
    //
    //        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "") == "delayed"){
    //
    //            showAlertMessage()
    //            statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
    //            return
    //        }
    //    }
    //
    
    func jointEvent(info:SlotInfo?){
        
        guard let slotInfo = info
            else{
                return
        }
        
        guard let eventId = slotInfo.callscheduleId
            else{
                return
        }
        

        
        guard let controller = UserCallController.instance()
            else{
                return
        }
        
        /*controller.feedbackListener = {(eventInfo) in
            
            guard let controller = ReviewController.instance() else{
                return
            }
            
            controller.eventInfo = eventInfo
            
            controller.dismissListner = {
                self.root?.refreshData()
            }
            
            self.root?.controller?.present(controller, animated: false, completion:{
            })
            
        }*/
        controller.eventId = String(eventId)
        controller.modalPresentationStyle = .fullScreen
        guard let controllers = InternetSpeedTestController.instance() else{
            return
        }
        
        controllers.onlySystemTest = true
        
        controllers.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controllers.topPresentedController = RootControllerManager().getCurrentController()
        controllers.onDoneBlock = { result in
            self.root?.controller?.present(controller, animated: false, completion: nil)
        }
        RootControllerManager().getCurrentController()?.present(controllers, animated: false, completion: {
        })
        
            
    }
    
    func systemTest(){
        
        //        guard let controller = SystemTestController.instance() else { return }
        //
        //        controller.isOnlySystemTest = true
        //        RootControllerManager().getCurrentController()?.present(controller, animated: true, completion: {
        //        })
        
        
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        
        controller.onlySystemTest = true
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        controller.topPresentedController = RootControllerManager().getCurrentController()
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    func refreshData(){
        
    }
}
