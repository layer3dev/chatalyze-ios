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
        
        guard let currentStatus = pageViewController?.getCurrentPageController() else{
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.first || currentStatus == SessionScheduleNewPageController.CurretController.none{
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.second {
            pageViewController?.setFirstController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.third {
            pageViewController?.setSecondController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fourth {
            pageViewController?.setThirdController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.fifth {
            pageViewController?.setFourthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.sixth {
            pageViewController?.setFifthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.seventh {
            pageViewController?.setSixthController()
            return
        }
        if currentStatus == SessionScheduleNewPageController.CurretController.eighth {            
            return
        }
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
        self.pageViewController?.pageDelegate = self
    }
    
    class func instance()->SessionScheduleNewController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionScheduleNew") as? SessionScheduleNewController
        return controller
    }
}


extension SessionScheduleNewController:SessionScheduleNewPageControllerDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return self.scheduleInfo
    }
    
    func backToRootController(){
    
        self.navigationController?.popViewController(animated: true)
    }
    
}
