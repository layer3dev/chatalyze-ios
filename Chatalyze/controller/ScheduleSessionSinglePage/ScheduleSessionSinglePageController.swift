//
//  ScheduleSessionSinglePageController.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Bugsnag

class ScheduleSessionSinglePageController: EditSessionFormController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Bugsnag.notifyError(NSError(domain:"com.customCrash:ScheduleSession", code:408, userInfo:nil))        
        SEGAnalytics.shared().track("Session Schedule")
    }
    
    override func rootInitialization() {
        
        DispatchQueue.main.async {
            self.rootView?.initializeVariable()
        }
    }
    
    override func fetchMinimumPlanPriceToScheuleIfExists(){
        
        self.showLoader()
        GetPlanRequestProcessor().fetch { (success,error,response) in
        
            self.fetchSupportedChats()
            if !success {
                return
            }
            
            guard let response = response else{
                return
            }
            
            let info = PlanInfo(info: response)
            self.rootView?.scheduleInfo?.minimumPlanPriceToSchedule = info.minPrice ?? 0.0
            self.rootView?.planInfo = info
        }
    }
    
    override func fetchSupportedChats(){
        
        FetchSupportedChats().fetch { (success,error,response) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                if !success{
                    return
                }
                guard let info = response else {
                    return
                }
                let supportedChatsJSONArray = info.arrayValue
                var requiredChats = [String]()
                for info in supportedChatsJSONArray{
                    if let existInfo = info.string{
                        requiredChats.append(existInfo)
                    }
                }
                self.rootView?.chatLengthArray = requiredChats                
                self.rootInitialization()
            }
        }
    }
    
    
    override func load(){
        
        self.rootView?.controller = self
        fetchMinimumPlanPriceToScheuleIfExists()
        paintInterface()
    }
    
   override func paintInterface(){
        
        rootView?.paintInteface()
        paintBackButton()
        paintNavigationTitle(text: "Schedule a Session")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        showNavigationBar()
    }
    
    override var rootView:ScheduleSessionSinglePageRootView? {
        return self.view as? ScheduleSessionSinglePageRootView
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override class func instance()->ScheduleSessionSinglePageController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSessionSinglePage", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionSinglePage") as? ScheduleSessionSinglePageController
        return controller
    }
    
}
