//
//  ScheduleSessionSinglePageController.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionSinglePageController: EditSessionFormController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SEGAnalytics.shared().track("Session Schedule")
    }
    
    override func rootInitialization() {
        
        DispatchQueue.main.async {
            
            self.rootView?.initializeVariable()
            //self.rootView?.fillInfo(info:self.eventInfo)
        }
    }
    
    override func fetchMinimumPlanPriceToScheuleIfExists(){
        
        self.showLoader()
        GetPlanRequestProcessor().fetch { (success,error,response) in
            self.stopLoader()
            if !success {
                return
            }
            
            guard let response = response else{
                return
            }
            
            let info = PlanInfo(info: response)
            self.rootView?.scheduleInfo?.minimumPlanPriceToSchedule = info.minPrice ?? 0.0
            
            self.rootView?.planInfo = info
            
            //Log.echo(key: "Earning Screen", text: "id of plan is \(info.id) name of the plan is \(info.name) min. price is \(info.minPrice) and the plan fee is \(info.chatalyzeFee)")
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
    
    override var rootView:ScheduleSessionSinglePageRootView?{
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
