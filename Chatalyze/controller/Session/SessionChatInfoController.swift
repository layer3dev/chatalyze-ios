//
//  SessionChatInfoController.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionChatInfoController: InterfaceExtendedController {
    
    var param = [String:Any]()
    var selectedDurationType:SessionTimeDateRootView.DurationLength? = SessionTimeDateRootView.DurationLength.none
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initializeVariable()
    }
    
    func initializeVariable(){

        rootView?.controller = self
        rootView?.param  = self.param
    }
    
    func updateRootInfo(){
        
        rootView?.param  = self.param
    }
    
    var rootView:SessionChatInfoRootView?{
        
        get{
            return self.view as? SessionChatInfoRootView
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
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

extension SessionChatInfoController{
    
    class func instance()->SessionChatInfoController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionChatInfo") as? SessionChatInfoController
        return controller
    }
}

