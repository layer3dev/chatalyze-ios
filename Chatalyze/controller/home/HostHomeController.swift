
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
        guard let controller = HostCallController.instance()
            else{
                return
        }
        
        guard let eventId = self.eventInfo?.id
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
