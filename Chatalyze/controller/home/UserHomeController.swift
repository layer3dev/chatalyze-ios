
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
        guard let controller = UserCallController.instance()
            else{
                return
        }
        
        guard let eventId = self.slotInfo?.callschedule?.id
            else{
                return
        }
        controller.eventId = String(eventId)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func fetchInfo(){
        self.showLoader()
        CallSlotFetch().fetchInfo { (success, slotInfo) in
            self.stopLoader()
            self.slotInfo = slotInfo
            self.rootView?.queueContainerView?.udpateView(callInfo: slotInfo)
        }
    }
}


extension UserHomeController{
    
    class func instance()->UserHomeController?{
        
        let storyboard = UIStoryboard(name: "home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "user_home") as? UserHomeController
        return controller
    }
}
