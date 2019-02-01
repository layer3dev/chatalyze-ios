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
    func backToRootController()
}

class SessionScheduleNewPageController: UIPageViewController,UIPageViewControllerDelegate {

    enum CurretController:Int{
       
        case none = 100
        case first = 0
        case second = 1
        case third = 2
        case fourth = 3
        case fifth = 4
        case sixth = 5
        case seventh = 6
        case eighth = 7
        case ninth = 8
    }
    
    private var currentController = CurretController.none
    private var firstController:ScheduleSessionNewDateController?
    private var secondController:ScheduleSessionNewTimeController?
    private var thirdController:ScheduleSessionNewDurationController?
    private var fourthController:ScheduleSessionSingleChatDurationController?
    private var fifthController:ScheduleSessionNewEarningController?
    private var sixthController:ScheduleSessionScreenShotAllowController?
    private var seventhController:ScheduleSessionNewReviewController?
    private var eighthController:ScheduleSessionNewDoneController?
    var pageDelegate:SessionScheduleNewPageControllerDelegate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.delegate = self
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
    
    func setFourthController(){
        
        guard let controller = getController(current: .fourth) else{
            return
        }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        currentController = .fourth
    }
    
    func setFifthController(){
        
        guard let controller = getController(current: .fifth) else{
            return
        }
        if currentController == .fifth{
            return
        }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        currentController = .fifth
    }
    
    func setSixthController(){
        
        guard let controller = getController(current: .sixth) else{
            return
        }
        if currentController == .sixth{
            return
        }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        currentController = .sixth
    }
    
    func setSeventhController(){
        
        guard let controller = getController(current: .seventh) else{
            return
        }
        if currentController == .seventh{
            return
        }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        currentController = .seventh
    }
    
    func setEighthController(){
        
        guard let controller = getController(current: .eighth) else{
            return
        }
        if currentController == .eighth{
            return
        }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        currentController = .eighth
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
        if current == .fourth {
            
            if let controller =  fourthController {
                return controller
            }
            guard let controller = ScheduleSessionSingleChatDurationController.instance() else{
                return nil
            }
            controller.delegate = self
            self.fourthController = controller
            return controller
        }
        if current == .fifth {
            
            if let controller = fifthController {
                return controller
            }
            guard let controller = ScheduleSessionNewEarningController.instance() else{
                return nil
            }
            controller.delegate = self
            self.fifthController = controller
            return controller
        }
        if current == .sixth {
            
            if let controller = sixthController {
                return controller
            }
            guard let controller = ScheduleSessionScreenShotAllowController.instance() else{
                return nil
            }
            controller.delegate = self
            self.sixthController = controller
            return controller
        }
        if current == .seventh {
            
            if let controller = seventhController {
                return controller
            }
            guard let controller = ScheduleSessionNewReviewController.instance() else{
                return nil
            }
            controller.delegate = self
            self.seventhController = controller
            return controller
        }
        if current == .eighth {
            
            if let controller = eighthController {
                return controller
            }
            guard let controller = ScheduleSessionNewDoneController.instance() else{
                return nil
            }
            controller.delegate = self
            self.eighthController = controller
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
    
    func goToTimeControllerScreen() {
        setSecondController()
    }
    
  
    func getSchduleSessionInfo() -> ScheduleSessionInfo? {
        return pageDelegate?.getSchduleSessionInfo()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionNewTimeControllerDelegate{
    
    func goToDurationScreen() {
        setThirdController()
    }
    
}

extension SessionScheduleNewPageController: ScheduleSessionNewDurationControllerDelegate{
   
    func goToSingleChatDurationScreen(){
        setFourthController()
    }
}


extension SessionScheduleNewPageController:ScheduleSessionSingleChatDurationControllerDelegate{

    func goToEarningScreen(){
        setFifthController()
    }
}


extension SessionScheduleNewPageController:ScheduleSessionNewEarningControllerDelegate{
   
    func goToScreenShotScreen(){
        setSixthController()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionScreenShotAllowControllerDelegate{
    
    func goToReviewScreen(){
        setSeventhController()
    }
}


extension SessionScheduleNewPageController:ScheduleSessionNewReviewControllerDelegate{
    
    func goToDoneScreen() {
        setEighthController()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionNewDoneControllerDelegate{
    
    func backToRootController(){
        pageDelegate?.backToRootController()
    }
}
