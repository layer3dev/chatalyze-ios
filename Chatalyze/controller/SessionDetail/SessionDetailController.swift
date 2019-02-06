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
        
        createEmptySlots()
        rootView?.controller = self
        rootView?.delegate = self
        rootView?.initialize()
        rootView?.fillInfo(info: self.eventInfo)
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
        
        self.startAnimating()
        
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
                    if info.startDate?.timeIntervalSince(requiredStartDate ?? Date()) == 0.0 && info.endDate?.timeIntervalSince(requiredEndDate ?? Date()) == 0.0{
                        
//                        Log.echo(key: "yud", text: "Yes event is matched with the time")
//                        if let date = requiredStartDate {
//
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "h:mm"
//                            dateFormatter.timeZone = TimeZone.current
//                            dateFormatter.locale = Locale.current
//                            let requireOne = dateFormatter.string(from: date)
//
//                            if let date = requiredEndDate{
//
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "h:mm a"
//                                dateFormatter.timeZone = TimeZone.current
//                                dateFormatter.locale = Locale.current
//                                Log.echo(key: "yud", text: " \(requireOne) - \(dateFormatter.string(from: date))")
//                            }
//                        }
                        emptySlotObj.slotInfo = info
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
