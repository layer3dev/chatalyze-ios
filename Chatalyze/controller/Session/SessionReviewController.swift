//
//  SessionReviewController.swift
//  Chatalyze
//
//  Created by Mansa on 23/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionReviewController: InterfaceExtendedController {

    var param = [String:Any]()
   
    var selectedDurationType:SessionTimeDateRootView.DurationLength? = SessionTimeDateRootView.DurationLength.none
    
    override func viewDidLayout() {
        super.viewDidLayout()
    
        initalializeVariable()
    }
    
    func initalializeVariable(){
        
        rootView?.controller = self
        rootView?.param  = self.param
        rootView?.fillInfo()
    }
    
    func updateRootInfo(){
        
        rootView?.param  = self.param
        rootView?.fillInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var rootView:SessionReviewRootView?{
        
        get{
            return self.view as? SessionReviewRootView
        }
    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SessionReviewController{
    
    class func instance()->SessionReviewController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionReview") as? SessionReviewController
        return controller
    }
}
