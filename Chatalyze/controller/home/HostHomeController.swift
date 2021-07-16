
//
//  HostHomeController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class HostHomeController: HomeController {
    
    private var eventInfo : EventInfo?
    private let eventListener = EventListener()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.echo(key: "yud", text: "I am host ")
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        eventListener.setListener(listener: nil)
    }
    
    @IBAction private func callAction(){
       
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        guard let eventId = eventInfo.id
            else{
                return
        }
        
        if(!eventInfo.isPreconnectEligible && eventInfo.isFuture){
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            controller.eventId = "\(eventId)"
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        guard let controller = HostCallController.instance()
        else {
            return
        }
        controller.eventId = String(eventId)
//        controller.callType = "green"
//        controller.callback = {
//            guard let controller = HostCallController.instance()
//            else {
//                return
//            }
//            controller.eventId = String(eventId)
//            controller.modalPresentationStyle = .fullScreen
//            self.present(controller, animated: true, completion: nil)
//        }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
     override func fetchInfo(showLoader : Bool){
        super.fetchInfo(showLoader : showLoader)
        if(showLoader){
            self.showLoader()
        }
        
        HostCallFetch().fetchInfo { (success, eventInfo) in
            if(showLoader){
                self.stopLoader()
            }
            
            self.eventInfo = eventInfo
            self.rootView?.queueContainerView?.udpateView(callInfo: eventInfo)
//            self.eventSlotListener.eventId = String(eventInfo?.id ?? 0)
        }
    }
    
    
    /*
     SocketService.getSocket().on('notification', function(data){
     if(!data) return;
     if(data.meta.activity_type != 'call_booked') return;
     
     Log.print("socket notification call_booked", "");
     //Log.print(JSON.stringify(data), "");
     
     var scheduleId = data.meta.callscheduleId;
     
     if(!scheduleId){
     return;
     }
     
     if(booking.id != scheduleId){
     Log.print("new slot is NOT of current event" + scheduleId, "");
     return;
     }
     */
    
    override func initializeListener(){
        super.initializeListener()
        
        eventListener.setListener {
            self.fetchInfo(showLoader: false)
        }
    }
    
}
