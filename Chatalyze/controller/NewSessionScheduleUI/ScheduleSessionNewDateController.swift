//
//  ScheduleSessionNewDateController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Analytics

protocol ScheduleSessionNewDateControllerDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToTimeControllerScreen()
}

class ScheduleSessionNewDateController: UIViewController {

    var delegate:ScheduleSessionNewDateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView?.delegate = self
        SEGAnalytics.shared().track("Action: Schedule Session - Select Date")
    }
    
    var rootView:SessionNewDateRootView?{
        return self.view as? SessionNewDateRootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    class func instance()-> ScheduleSessionNewDateController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewDate") as? ScheduleSessionNewDateController
        return controller
    }
    
}

extension ScheduleSessionNewDateController:SessionNewDateRootViewDelegate{
    
    func getSchduleSessionInfo() -> ScheduleSessionInfo? {
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
        
        Log.echo(key: "yud", text: "Next of the date is calling")
        delegate?.goToTimeControllerScreen()
    }
}
