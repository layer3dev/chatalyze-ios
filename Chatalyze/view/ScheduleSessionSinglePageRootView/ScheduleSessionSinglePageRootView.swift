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
                self.controller?.alert(withTitle: AppInfoConfig.appName, message: "Session created successfully", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in                    
                    self.controller?.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
}
