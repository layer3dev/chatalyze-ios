//
//  MyTicketesAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 22/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class MyTicketesAdapter: ExtendedView {
    
    @IBOutlet var myTicketsCollectionView:UICollectionView?
    var layout = UICollectionViewFlowLayout()
    var root:MyTicketsRootView?
    var ticketsListingArray = [SlotInfo]()
    var featureHeight:CGFloat = 0.0
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func initailizeAdapter(info:[SlotInfo]?){
        
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
        
        self.myTicketsCollectionView?.layoutIfNeeded()
        self.myTicketsCollectionView?.dataSource = self
        self.myTicketsCollectionView?.delegate = self
        let width = root?.superview?.frame.size.width ?? 60.0
        let height:CGFloat = self.myTicketsCollectionView?.bounds.height ?? 0.0
        Log.echo(key: "yud", text: "The height of the Collection is \(height)")
        layout.itemSize = CGSize(width: width-60, height: height-15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0)
        //layout.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        myTicketsCollectionView?.collectionViewLayout = layout
        myTicketsCollectionView?.alwaysBounceVertical = false
    }    
}

extension MyTicketesAdapter:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ticketsListingArray.count
        //    return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = myTicketsCollectionView?.dequeueReusableCell(withReuseIdentifier: "MyTicketsCell", for: indexPath) as? MyTicketsCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        if indexPath.row >= ticketsListingArray.count{
            return cell
        }
        cell.fillInfo(info: ticketsListingArray[indexPath.row])
        return cell
    }
}

extension MyTicketesAdapter:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


extension MyTicketesAdapter:MyTicketCellDelegate{
    
    func jointEvent(info:SlotInfo?){
        
        Log.echo(key: "yud", text: "The event Id id \(info?.callscheduleId)")
        Log.echo(key: "yud", text: "The value of the notified is\(info?.notified)")
        Log.echo(key: "yud", text: "The value of the started is\(info?.started)")
        
        guard let slotInfo = info
            else{
                return
        }
        
        guard let eventId = slotInfo.callscheduleId
            else{
                return
        }
        
        //Verifying that event is delayed or not started yet
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "" ) == ""){
            
            let alert = UIAlertController(title: "Chatalyze", message: "Event is not started yet!!", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert) in
                
                self.refreshData()
            }
            alert.addAction(ok)
            self.root?.controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "") == "delayed"){
            
            let alert = UIAlertController(title: "Chatalyze", message: "This event has been delayed. Please stay tuned for an updated start time.", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert) in
                
                self.refreshData()
            }
            alert.addAction(ok)
            self.root?.controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        //End
        
        if(!slotInfo.isPreconnectEligible && slotInfo.isFuture){
            
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            controller.eventId = "\(eventId)"
            self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        
        guard let controller = UserCallController.instance()
            else{
                return
        }
        
        controller.eventExpiredHandler = {(success,eventInfo) in
            
            guard let controller = ReviewController.instance() else{
                return
            }
            controller.eventInfo = eventInfo
            controller.dismissListner = {
                self.root?.refreshData()
            }
            self.root?.controller?.present(controller, animated: true, completion:{
            })
        }
        controller.eventId = String(eventId)
        self.root?.controller?.present(controller, animated: true, completion: nil)
    }
    
    func refreshData(){
        
        root?.refreshData()
    }
}

