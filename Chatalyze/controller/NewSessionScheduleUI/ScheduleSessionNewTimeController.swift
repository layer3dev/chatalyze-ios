//
//  ScheduleSessionNewTimeController.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionNewTimeControllerDelegate {
    
    func goToDurationScreen()
    func getSchduleSessionInfo()->ScheduleSessionInfo?
}

class ScheduleSessionNewTimeController: UIViewController {

    var delegate:ScheduleSessionNewTimeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rootView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    var rootView:SessionNewTimeRootView?{
        return self.view as? SessionNewTimeRootView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()-> ScheduleSessionNewTimeController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewTime") as? ScheduleSessionNewTimeController
        return controller
    }

}

extension ScheduleSessionNewTimeController:SessionNewTimeRootViewDelegate{
    
    func getSchduleSessionInfo() -> ScheduleSessionInfo? {    
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
        
        Log.echo(key: "yud", text: "Next of the time is calling")
        delegate?.goToDurationScreen()
    }
}
