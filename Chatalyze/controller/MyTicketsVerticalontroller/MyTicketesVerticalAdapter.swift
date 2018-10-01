//
//  MyTicketesVerticalAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

class MyTicketesVerticalAdapter: ExtendedView {
    
   
    var root:MyTicketsVerticalRootView?
    var ticketsListingArray = [EventSlotInfo]()
   
    var myTicketsVerticalTableView:UITableView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        myTicketsVerticalTableView?.separatorStyle = .none
        myTicketsVerticalTableView?.dataSource = self
        myTicketsVerticalTableView?.delegate = self
        myTicketsVerticalTableView?.reloadData()
    }
    
    func initailizeAdapter(info:[EventSlotInfo]?){
        
        guard let info = info else {
            return
        }
        Log.echo(key: "yud", text: "tickets listing is \(info.count)")
        ticketsListingArray = info
        //initializeCollectionFlowLayout()
        
        myTicketsVerticalTableView?.reloadData()
    }

}

extension MyTicketesVerticalAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        return ticketsListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTicketsVerticalCell", for: indexPath) as? MyTicketsVerticalCell else {
            
            return UITableViewCell()
        }
//        if indexPath.row < self.memoriesListingArray.count{
//
//            cell.fillInfo(info:self.memoriesListingArray[indexPath.row])
//            cell.controller = self.controller
//            return cell
//        }
        return cell
    }
}

extension MyTicketesVerticalAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 502.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        guard let controller = GreetingInfoController.instance() else {
    //            return
    //        }
    //        if indexPath.row < self.PaymentListingArray.count {
    //
    //            controller.info = self.PaymentListingArray[indexPath.row]
    //        }
    //        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    //    }
}


extension MyTicketesVerticalAdapter:MyTicketCellDelegate{
    
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
        
        //Verify for delay and not started
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "" ) == ""){
            
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            
            controller.eventId = "\(eventId)"
            
            self.root?.controller?.navigationController?.pushViewController(controller, animated: false)
            return
        }
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "") == "delayed"){
            
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            
            controller.eventId = "\(eventId)"
            self.root?.controller?.navigationController?.pushViewController(controller, animated: false)
            return
        }
        
        //End
        if(!slotInfo.isPreconnectEligible && slotInfo.isFuture){
            
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            
            controller.eventId = "\(eventId)"
            self.root?.controller?.navigationController?.pushViewController(controller, animated: false)
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
            self.root?.controller?.present(controller, animated: false, completion:{
            })
        }
        controller.eventId = String(eventId)
        self.root?.controller?.present(controller, animated: false, completion: nil)
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
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    func refreshData(){
        
        root?.refreshData()
    }
}
