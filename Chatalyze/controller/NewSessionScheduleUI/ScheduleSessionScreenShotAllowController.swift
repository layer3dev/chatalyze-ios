//
//  ScheduleSessionScreenShotAllowController.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionScreenShotAllowControllerDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToReviewScreen()
}

class ScheduleSessionScreenShotAllowController: UIViewController {
    
    var delegate:ScheduleSessionScreenShotAllowControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    var rootView:ScheduleSessionScreenShotRootView?{
        return self.view as? ScheduleSessionScreenShotRootView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()-> ScheduleSessionScreenShotAllowController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionScreenShotAllow") as? ScheduleSessionScreenShotAllowController
        return controller
    }

}

extension ScheduleSessionScreenShotAllowController:ScheduleSessionScreenShotRootViewDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return delegate?.getSchduleSessionInfo()
    }
    func goToNextScreen(){
        
        delegate?.goToReviewScreen()
    }
}
