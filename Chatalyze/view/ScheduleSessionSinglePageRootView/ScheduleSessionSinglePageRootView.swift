//
//  ScheduleSessionSinglePageRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 04/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

//EditSessionFormRootView
class ScheduleSessionSinglePageRootView : EditSessionFormRootView {
    
   override func save(){
        
        guard let paramForUpload = self.getParam() else{
            return
        }    
    
        self.controller?.showLoader()    
        ScheduleSessionRequest().save(params: paramForUpload) { (success, message, response) in
            
            Log.echo(key: "yud", text: "Response in succesful event creation is \(String(describing: response))")
            
            DispatchQueue.main.async {
                
                self.controller?.stopLoader()
                
                if !success{
                    
                    self.controller?.alert(withTitle: AppInfoConfig.appName, message: message, successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                        
                        //self.controller?.navigationController?.popToRootViewController(animated: true)
                    })
                    return
                }
                
                SEGAnalytics.shared().track("Session Scheduled")
                guard let controller = ScheduleSessionSinglePageDoneController.instance() else{
                    return
                }
                
                self.controller?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK:- Segment.io Tracking Method.
    
    override func titleTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Add Title")
    }
    
    override func dateTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Select Date")
    }
    
    override func timeTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Select Start Time")
    }
    
    override func ChatLengthTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Select 1:1 Chat Length")
    }
    
    override func SessionLengthTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Select Session Length")
    }
    
    override func priceFieldTracking(){
        
        SEGAnalytics.shared().track("Action: Schedule Session - Select Chat Price")
    }
}
