//
//  EditProfileController.swift
//  Chatalyze
//
//  Created by Mansa on 16/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EditProfileController: InterfaceExtendedController {
    
    @IBOutlet var rootView:EditProfileRootview?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
        SEGAnalytics.shared().track("Profile Edit")
        
        //        [[SEGAnalytics sharedAnalytics] track:@"Pro Trial SignUp"];
        //
        //        analytics.track('Session Schedule');
        //        analytics.track('Action: Schedule Session - Add Title)'
        //            analytics.track('Action: Schedule Session - Select Date)'
        //                analytics.track('Action: Schedule Session - Select Start Time)'
        //                    analytics.track('Action: Schedule Session - Select Session Length)'
        //                        analytics.track('Action: Schedule Session - Select 1:1 Chat Length)'
        //                            analytics.track('Action: Schedule Session - Select Chat Price)'
        //                                analytics.track('Session Scheduled');
        //                                analytics.track('Session Enter Host');
        //                                analytics.track('My Tickets Page');
        //                                analytics.track('Chat Enter Attendee')
        //                                analytics.track('System Test');
        //                                analytics.track('My Memories Page');
        //

    }
    
    override func viewAppeared() {
        super.viewAppeared()
     
        initializationVariable()
        fetchInfo()
        rootView?.initializeThroughController()
    }
    
    func fetchInfo(){
        
        self.showLoader()
        FetchProfileProcessor().fetch { (success, message, response) in
            
            self.stopLoader()
            if success{
                
                self.rootView?.fillInfo()
            }
            else{
                self.alert(withTitle: AppInfoConfig.appName, message: message, successTitle: "Ok", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func painInterface(){
        
        paintBackButton()
        paintSettingButton()
    }
    
    func initializationVariable(){
        
        rootView?.controller = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Settings")
    }
    
    class func instance()->EditProfileController?{
        
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileController
        return controller
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditProfileController{
}

