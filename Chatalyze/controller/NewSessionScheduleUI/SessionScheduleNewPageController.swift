//
//  SessionScheduleNewPageController.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionScheduleNewPageControllerDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
}

class SessionScheduleNewPageController: UIPageViewController {

    enum CurretController:Int{
        
        case first = 0
        case second = 1
        case third = 2
        case fourth = 3
        case fifth = 4
        case none = 5
    }
    
    private var currentController = CurretController.none
    private var firstController:ScheduleSessionNewDateController?
    private var secondController:ScheduleSessionNewTimeController?
    private var thirdController:ScheduleSessionNewDurationController?
    var pageDelegate:SessionScheduleNewPageControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstController()
        //Do any additional setup after loading the view.
    }
    
    func setFirstController(){
        
        guard let controller = getController(current: .first) else{
            return
        }
        if currentController == .first{
            return
        }
        setViewControllers([controller], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        currentController = .first
    }
    
    
    func setSecondController(){
        
        guard let controller = getController(current: .second) else{
            return
        }
        if currentController == .second{
            return
        }
        setViewControllers([controller], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        currentController = .second
    }
    
    func setThirdController(){
        
        guard let controller = getController(current: .third) else{
            return
        }
        if currentController == .third{
            return
        }
        setViewControllers([controller], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        currentController = .third
    }
    
    
    func getController(current:CurretController)->UIViewController?{
        
        if current == .first {
            
            if let controller =  firstController {
                return controller
            }
            guard let controller = ScheduleSessionNewDateController.instance() else{
                return nil
            }
            controller.delegate = self
            self.firstController = controller
            return controller
        }
        if current == .second {
            
            if let controller =  secondController {
                return controller
            }
            guard let controller = ScheduleSessionNewTimeController.instance() else{
                return nil
            }
            controller.delegate = self
            self.secondController = controller
            return controller
        }
        if current == .third {
            
            if let controller =  thirdController {
                return controller
            }
            guard let controller = ScheduleSessionNewDurationController.instance() else{
                return nil
            }
            controller.delegate = self
            self.thirdController = controller
            return controller
        }
        return nil
    }
    
    func getCurrentPageController()->CurretController{
        return self.currentController
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

extension SessionScheduleNewPageController:ScheduleSessionNewDateControllerDelegate{
  
    func getSchduleSessionInfo() -> ScheduleSessionInfo? {
        return pageDelegate?.getSchduleSessionInfo()
    }
    
    func showNextScreen(){
        setSecondController()
    }
    
}

extension SessionScheduleNewPageController:ScheduleSessionNewTimeControllerDelegate{
    
    func goToNextScreen() {
        
        setThirdController()
    }
}

extension SessionScheduleNewPageController: ScheduleSessionNewDurationControllerDelegate{
}



