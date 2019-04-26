//
//  ScheduleSessionNewEarningController.swift
//  Chatalyze
//
//  Created by mansa infotech on 31/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionNewEarningControllerDelegate {
  
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToDonationScreen()
}

class ScheduleSessionNewEarningController: UIViewController {

    var delegate:ScheduleSessionNewEarningControllerDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.delegate = self
        SEGAnalytics.shared().track("Action: Schedule Session - Select Chat Price")        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.hideNavigationBar()
        rootView?.fillDataIfExists()
    }
    
    var rootView:ScheduleSessionEarningRootView?{
        return self.view as? ScheduleSessionEarningRootView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->ScheduleSessionNewEarningController? {
      
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewEarning") as? ScheduleSessionNewEarningController
        return controller
    }
}


extension ScheduleSessionNewEarningController:ScheduleSessionEarningRootViewDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){       
        delegate?.goToDonationScreen()
    }
}
