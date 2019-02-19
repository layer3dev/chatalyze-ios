//
//  ScheduleSessionDonationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionDonationControllerDelegate {
    
    func backToRootController()
    func goToScreenShotScreen()
    func getSchduleSessionInfo() -> ScheduleSessionInfo?
}

class ScheduleSessionDonationController: UIViewController {
    
    var delegate:ScheduleSessionDonationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        initializeRootView()
    }
    
    func initializeRootView(){
        rootView?.delegate = self
    }
    
    var rootView:ScheduleSessionDonationRootView?{
        return self.view as? ScheduleSessionDonationRootView
    }
    
    @IBAction func backToSession(sender:UIButton){
        delegate?.backToRootController()
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     
    }
    */
    
    class func instance()->ScheduleSessionDonationController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSessionDonation") as? ScheduleSessionDonationController
        return controller
    }
}

extension ScheduleSessionDonationController:ScheduleSessionDonationRootViewDelegate{
    
    func getSchduleSessionInfo() -> ScheduleSessionInfo? {
        return delegate?.getSchduleSessionInfo()
    }
    
    func goToNextScreen() {
        delegate?.goToScreenShotScreen()
    }
}
