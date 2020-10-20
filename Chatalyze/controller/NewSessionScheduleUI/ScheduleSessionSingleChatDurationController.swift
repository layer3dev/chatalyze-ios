//
//  ScheduleSessionSingleChatDurationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Analytics

protocol ScheduleSessionSingleChatDurationControllerDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToEarningScreen()
}

class ScheduleSessionSingleChatDurationController: UIViewController {

    var delegate:ScheduleSessionSingleChatDurationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.delegate = self
        SEGAnalytics.shared().track("Action: Schedule Session - Select 1:1 Chat Length)")        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView?.paintRootWithExistingData()
    }
    
    var rootView:SingleChatDurationRootView?{
        return self.view as? SingleChatDurationRootView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()-> ScheduleSessionSingleChatDurationController?{
     
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionSingleChatDuration") as? ScheduleSessionSingleChatDurationController
        return controller
    }
}


extension ScheduleSessionSingleChatDurationController: SingleChatDurationRootViewDelegate{
 
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
       return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
        delegate?.goToEarningScreen()
    }
}
