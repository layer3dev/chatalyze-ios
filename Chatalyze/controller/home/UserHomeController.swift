
//
//  UserHomeController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserHomeController: HomeController {
    
    private var slotInfo : EventSlotInfo?
    
    @IBAction private func callAction(){
        
        guard let slotInfo = slotInfo
            else{
                return
        }
        
        guard let eventId = slotInfo.callschedule?.id
            else{
                return
        }
        
        if(!slotInfo.isPreconnectEligible && slotInfo.isFuture){
            
            guard let controller = HostEventQueueController.instance()
                else{
                    return
            }
            controller.eventId = "\(eventId)"
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        guard let controller = UserCallController.instance()
            else{
                return
        }
        
        controller.eventId = String(eventId)
        self.present(controller, animated: true, completion: nil)
    }
  
    override func fetchInfo(showLoader : Bool){
        
        super.fetchInfo(showLoader : showLoader)
        if(showLoader){
            self.showLoader()
        }
        
        CallSlotFetch().fetchInfo { (success, slotInfo) in
            if(showLoader){
                self.stopLoader()
            }
            
            self.slotInfo = slotInfo
            self.rootView?.queueContainerView?.udpateView(callInfo: slotInfo)
        }
    }
    
    override func initializeListener(){
        super.initializeListener()
        
        UserSocket.sharedInstance?.socket?.on("call_booked_success", callback: { (data, ack) in
            self.fetchInfo(showLoader: false)
        })

    
    }
}


extension UserHomeController{
    
    class func instance()->UserHomeController?{
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "user_home") as? UserHomeController
        return controller
    }
}
