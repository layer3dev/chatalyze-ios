//
//  ScheduleSessionNewTitleController.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionNewTitleControllerDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToDateController()
}

class ScheduleSessionNewTitleController: UIViewController {
    
    var delegate:ScheduleSessionNewTitleControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.hideNavigationBar()
    }
    
    var rootView:ScheduleSessionTitleRootView?{
        return self.view as? ScheduleSessionTitleRootView
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    class func instance()->ScheduleSessionNewTitleController? {
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionNewTitle") as? ScheduleSessionNewTitleController
        return controller
    }
}


extension ScheduleSessionNewTitleController:ScheduleSessionTitleRootViewDelegate{
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?{
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen(){
        delegate?.goToDateController()
    }
}

