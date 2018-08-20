//
//  SessionTimeDateController.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionTimeDateController: InterfaceExtendedController {

    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var rootView:SessionTimeDateRootView?{
        get{
         
            return self.view as? SessionTimeDateRootView
        }
    }
}

extension SessionTimeDateController{
    class func instance()->SessionTimeDateController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionTimeDate") as? SessionTimeDateController
        return controller
    }
}
