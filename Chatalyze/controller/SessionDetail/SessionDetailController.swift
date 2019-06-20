//
//  SessionDetailController.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionDetailController: InterfaceExtendedController {
    
    var eventInfo:EventInfo?
    var emptySlotList = [EmptySlotInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.controller = self
        rootView?.delegate = self
        
        //rootView?.fillInfo(info: self.eventInfo)
        
        fetchNewInfo()
    }
    
    func fetchNewInfo(){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        self.showLoader()
        CallEventInfo().fetchInfo(eventId:"\(id)") { (success, info) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                if let newInfo = info{
                    
                    self.eventInfo = newInfo
                    self.createEmptySlots()
                    self.rootView?.initialize()
                    self.rootView?.fillInfo(info: self.eventInfo)
                    return
                }
                self.createEmptySlots()
                self.rootView?.initialize()
                self.rootView?.fillInfo(info: self.eventInfo)
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    var rootView:SessionDetailRootView?{
        return self.view as? SessionDetailRootView
    }
    
    func cancelSession(){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        self.showLoader()
        CancelSessionProcessor().cancel(id: "\(id)") {(success, response) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createEmptySlots(){
        
        guard let startTime = self.eventInfo?.startDate else {
            return
        }
        
        guard let endTime = self.eventInfo?.endDate else {
            return
        }
        
        let timeDiffreneceOfSlots = endTime.timeIntervalSince(startTime)
        
        let totalminutes = (timeDiffreneceOfSlots/60)
        
        guard let duration = self.eventInfo?.duration else{
            return
        }
        
        let totalSlots = Int(totalminutes/duration)
        
        for i in 0..<totalSlots{
            
            let requiredStartDate = self.eventInfo?.startDate?.addingTimeInterval(TimeInterval(duration*60.0*Double(i)))
            let requiredEndDate = requiredStartDate?.addingTimeInterval(TimeInterval(duration*60.0))
            let emptySlotObj = EmptySlotInfo(startDate: requiredStartDate, endDate: requiredEndDate)
            self.emptySlotList.append(emptySlotObj)
            if let alreadyBookedInfo = self.eventInfo?.slotsInfoLists{
                for info in alreadyBookedInfo {
                    
                    Log.echo(key: "yud", text: "Info name is \(info.user?.id) second \(info.user?.id) third \(info.user?.id)")
                    
                    if info.startDate?.timeIntervalSince(requiredStartDate ?? Date()) == 0.0 && info.endDate?.timeIntervalSince(requiredEndDate ?? Date()) == 0.0{
                        emptySlotObj.slotInfo = info
                        Log.echo(key: "yud", text: "Empty Slot user name is \(emptySlotObj.slotInfo?.user?.firstName)")
                        break
                    }
                }
            }
        }
        self.stopLoader()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func menuAction(){
        RootControllerManager().getCurrentController()?.toggleAnimation()
    }
    
    func backToHostDashboard(){
        self.navigationController?.popViewController(animated: true)
    }
    
    class func instance()-> SessionDetailController? {
        
        let storyboard = UIStoryboard(name: "SessionDetail", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionDetail") as? SessionDetailController
        return controller
    }
}


extension SessionDetailController:SessionDetailRootViewDelegate{
    
    func getEmptySlots()->[EmptySlotInfo]?{
        return self.emptySlotList
    }
    
}
