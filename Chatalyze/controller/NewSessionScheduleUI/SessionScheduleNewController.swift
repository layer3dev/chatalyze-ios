//
//  SessionScheduleNewController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionScheduleNewController: InterfaceExtendedController {
    
    var pageViewController:SessionScheduleNewPageController?
    var scheduleInfo = ScheduleSessionInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    @IBAction func backButton(sender:UIButton){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        self.pageViewController = segue.destination as? SessionScheduleNewPageController
    }
    
    class func instance()->SessionScheduleNewController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionScheduleNew") as? SessionScheduleNewController
        return controller
    }
}
