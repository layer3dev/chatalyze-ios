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
    func updateProgress()
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
        case title = 9
    }
    
    private var currentController = CurretController.none
    private var titleController:ScheduleSessionNewTitleController?
    private var firstController:ScheduleSessionNewDateController?
    private var secondController:ScheduleSessionNewTimeController?
    private var thirdController:ScheduleSessionNewDurationController?
    private var fourthController:ScheduleSessionSingleChatDurationController?
    private var fifthController:ScheduleSessionNewEarningController?
    private var sixthController:ScheduleSessionDonationController?
    private var seventhController:ScheduleSessionScreenShotAllowController?
    private var eighthController:ScheduleSessionNewReviewController?
    private var ninthController:ScheduleSessionNewDoneController?
    var pageDelegate:SessionScheduleNewPageControllerDelegate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.delegate = self
        setTitleController()
        //Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        Log.echo(key: "yud", text: "Current Controller is \(pageViewController.viewControllers?.first)")        
    }
    
    func setTitleController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .title) else{
            return
        }
        if currentController == .title{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .title
        pageDelegate?.updateProgress()
    }
    
    func setFirstController(direction:NavigationDirection = NavigationDirection.forward){

        guard let controller = getController(current: .first) else{
            return
        }
        if currentController == .first{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .first
        pageDelegate?.updateProgress()
    }
    
    func setSecondController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .second) else{
            return
        }
        if currentController == .second{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .second
        pageDelegate?.updateProgress()
    }
    
    
    func setThirdController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .third) else{
            return
        }
        if currentController == .third{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .third
        pageDelegate?.updateProgress()
    }
    
    
    func setFourthController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .fourth) else{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .fourth
        pageDelegate?.updateProgress()
    }
    
    
    func setFifthController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .fifth) else{
            return
        }
        if currentController == .fifth{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .fifth
        pageDelegate?.updateProgress()
    }
    
    
    func setSixthController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .sixth) else{
            return
        }
        if currentController == .sixth{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .sixth
        pageDelegate?.updateProgress()
    }
    
    
    func setSeventhController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .seventh) else{
            return
        }
        if currentController == .seventh{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .seventh
        pageDelegate?.updateProgress()
    }
    
    func setNinthController(direction:NavigationDirection = NavigationDirection.forward){
        
        guard let controller = getController(current: .ninth) else{
            return
        }
        if currentController == .ninth{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .ninth
        pageDelegate?.updateProgress()
    }
    
    func setEighthController(direction:NavigationDirection = NavigationDirection.forward){

        guard let controller = getController(current: .eighth) else{
            return
        }
        if currentController == .eighth{
            return
        }
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentController = .eighth
        pageDelegate?.updateProgress()
    }
    
    
    func getController(current:CurretController)->UIViewController?{
      
        if current == .title {
            
            if let controller =  titleController {
                return controller
            }
            guard let controller = ScheduleSessionNewTitleController.instance() else{
                return nil
            }
            controller.delegate = self
            self.titleController = controller
            return controller
        }
        
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
            guard let controller = ScheduleSessionDonationController.instance() else{
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
            
            guard let controller = ScheduleSessionScreenShotAllowController.instance() else{
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
            
            guard let controller = ScheduleSessionNewReviewController.instance() else{
                return nil
            }
            controller.delegate = self
            self.eighthController = controller
            return controller
        }
        if current == .ninth {
            
            if let controller = ninthController {
                return controller
            }
            guard let controller = ScheduleSessionNewDoneController.instance() else{
                return nil
            }
            controller.delegate = self
            self.ninthController = controller
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
    
    func goToDonationScreen(){
        setSixthController()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionScreenShotAllowControllerDelegate{
    
    func goToReviewScreen(){
        setEighthController()
    }
}


extension SessionScheduleNewPageController:ScheduleSessionNewReviewControllerDelegate{
    
    func goToDoneScreen(){
     
       setNinthController()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionNewDoneControllerDelegate{
    
    func backToRootController(){
        
        pageDelegate?.backToRootController()
    }
}

extension SessionScheduleNewPageController:ScheduleSessionDonationControllerDelegate{
    
    func goToScreenShotScreen(){    
        setSeventhController()
    }
}


extension SessionScheduleNewPageController:ScheduleSessionNewTitleControllerDelegate{
    
    func goToDateController(){
        setFirstController()
    }
}
