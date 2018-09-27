//
//  ContainerNavigationController.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ContainerNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        // Do any additional setup after loading the view.
    }
    
    func initialize(){
        
        guard let eventController = EventController.instance()
            else{
            return
        }
        
        guard let hostDashBoardController = HostDashboardController.instance()
            else{
                return
        }
        if let role = SignedUserInfo.sharedInstance?.role{
            if role == .analyst  {
                self.viewControllers = [hostDashBoardController]
            }else{                              
                self.viewControllers = [eventController]
            }
        }
    }
    
//    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//
//        if let selected = selectedViewController {
//            return selected.supportedInterfaceOrientations
//        }
//        return super.supportedInterfaceOrientations
//    }
//
//    open override var shouldAutorotate: Bool {
//
//        if let selected = selectedViewController {
//            return selected.shouldAutorotate
//        }
//        return super.shouldAutorotate
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
