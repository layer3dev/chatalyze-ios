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
    var delegate:UpdateForEditScheduleSessionDelgete?
    var editedParam = [String:Any]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        mergeEditedtoRealParam()
        initalializeVariable()
    }
    
    func mergeEditedtoRealParam(){
        
        //Param meters edited in the editScheduleController is merging
    
        for (key,value) in editedParam{
            self.param[key] = value
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView?.editedParam = self.editedParam
        rootView?.fillInfo()
    }
    
  
    func initalializeVariable(){
        
        rootView?.controller = self
        rootView?.editedParam = self.editedParam
        rootView?.param  = self.param
        rootView?.fillInfo()
    }
    
    func updateRootInfo(){
        
        rootView?.param  = self.param
        rootView?.fillInfo()
    }
    
    @IBAction func editSchecduleAction(sender:UIButton?){
        
        guard let controller = EditScheduledSessionController.instance() else{
            return
        }
        //Merging are doing in  order to get the updated param
        mergeEditedtoRealParam()
        controller.fillInfo(param:self.param,totalDurationofEvent:(rootView?.totalDurationOfEvent) ?? 0)
        
        controller.rootView?.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
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


extension SessionReviewController:UpdateForEditScheduleSessionDelgete{
    
    func updatedEditedParams(info: [String : Any]) {
        
        editedParam = info
        mergeEditedtoRealParam()
        updateRootInfo()
    }
}
