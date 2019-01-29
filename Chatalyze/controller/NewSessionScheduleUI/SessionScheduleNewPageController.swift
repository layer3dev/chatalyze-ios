//
//  SessionScheduleNewPageController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionScheduleNewPageController: UIPageViewController {

    enum CurretController:Int{
        
        case first = 0
        case second = 1
        case third = 2
        case fourth = 3
        case fifth = 4
    }
    
    var currentController:CurretController = CurretController.first
    var firstController:ScheduleSessionNewDateController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let controller = getController(current: .first) else{
            return
        }
        setViewControllers([controller], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func getController(current:CurretController)->UIViewController?{
        
        if current == .first{
            
            if let controller =  firstController {
                return controller
            }
            guard let controller = ScheduleSessionNewDateController.instance() else{
                return nil
            }
            return controller
        }
        return nil
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()-> SessionScheduleNewPageController?{
        
        let storyboard = UIStoryboard(name: "SessionScheduleNew", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionScheduleNewPage") as? SessionScheduleNewPageController
        return controller
    }
}

extension SessionScheduleNewPageController{
}
