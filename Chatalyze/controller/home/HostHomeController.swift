
//
//  HostHomeController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostHomeController: HomeController {
    
    private var eventInfo : EventInfo?
    
    
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
            else{
                return
        }
        
        
        controller.eventId = String(eventId)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func fetchInfo(){
        super.fetchInfo()
        
        self.showLoader()
        HostCallFetch().fetchInfo { (success, eventInfo) in
            self.stopLoader()
            self.eventInfo = eventInfo
            self.rootView?.queueContainerView?.udpateView(callInfo: eventInfo)
        }
    }
}
