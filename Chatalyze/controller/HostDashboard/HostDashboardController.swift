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
//        controller.info = self.info
       // controller.isOnlySystemTest = true
       // controller.rootController = self.controller?.presentingControllerObj
//        controller.onSuccessTest = {(success) in
//            self.skipAction(sender: nil)
//        }
//        controller.dismissListner = {(success) in
//            self.controller?.dismiss(animated: false, completion: {
//                DispatchQueue.main.async {
//                    if let listner = self.controller?.dismissListner{
//                        listner(success)
//                    }
//                }
//            })
//        }
        
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
