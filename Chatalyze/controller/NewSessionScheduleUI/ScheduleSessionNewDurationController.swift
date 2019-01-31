//
//  ScheduleSessionNewDurationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionNewDurationControllerDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
}

class ScheduleSessionNewDurationController: InterfaceExtendedController {

    var delegate:ScheduleSessionNewDurationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    var rootView:SessionNewDurationRootView?{
        return self.view as? SessionNewDurationRootView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()-> ScheduleSessionNewDurationController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewDuration") as? ScheduleSessionNewDurationController
        return controller
    }

}

extension ScheduleSessionNewDurationController:SessionNewDurationRootViewDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
    }
}
