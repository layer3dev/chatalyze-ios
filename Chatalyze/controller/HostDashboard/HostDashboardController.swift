//
//  HostDashboardController.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostDashboardController: MyScheduledSessionsController {
    
    @IBOutlet var tableHeight:NSLayoutConstraint?
    @IBOutlet var scheduleSessionBtnContainer:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        roundSessionButton()
    }
    
    func roundSessionButton(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            scheduleSessionBtnContainer?.layer.cornerRadius = 7
            scheduleSessionBtnContainer?.layer.masksToBounds = true
            return
        }
        scheduleSessionBtnContainer?.layer.cornerRadius = 4
        scheduleSessionBtnContainer?.layer.masksToBounds = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scheduleSessionAction(sender:UIButton){

        guard let controller = ScheduleSessionController.instance() else{
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func systemTestAction(sender:UIButton){
      
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func updateScrollViewWithTable(height:CGFloat){
        
        Log.echo(key: "yud", text: "The height of the table is \(height)")
        
        tableHeight?.constant = height
        self.updateViewConstraints()
        self.view.layoutIfNeeded()
    }
    
   
    override class func instance()->HostDashboardController?{
        
        let storyboard = UIStoryboard(name: "HostDashBoard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HostDashboard") as? HostDashboardController
        return controller
    }
}
