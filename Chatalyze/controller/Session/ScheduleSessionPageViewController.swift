//
//  ScheduleSessionPageViewController.swift
//  Chatalyze
//
//  Created by Mansa on 29/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionPageViewController: UIPageViewController {
    
    
    var activeControllerListner:((ScheduleSessionController.CurrentControllerFlag)->())?
    let timeDateController = SessionTimeDateController.instance()
    let chatController = SessionChatInfoController.instance()
    let reviewController = SessionReviewController.instance()
    let doneController = SessionDoneController.instance()
    
    var timeSuccessHandler:(()->())?
    var chatSuccessHandler:(()->())?
    var reviewSuccessHandler:(()->())?
    
    var sessionPageDelegate:ScheduleSessionPageInterface?
    
    lazy var pages: [UIViewController] = ({
        return [
            timeDateController,
            chatController,
            reviewController,
            doneController
        ]
        }() as! [UIViewController])
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        initializeVariable()
        setFirstController()
        initializeActiveControllersListner()
        //Do any additional setup after loading the view.
    }
    
    func initializeActiveControllersListner(){
        
        timeDateController?.rootView?.activeControllerListner = {(activatedController) in
            self.activeControllerListner?(activatedController)
        }
        chatController?.rootView?.activeControllerListner = {(activatedController) in
            self.activeControllerListner?(activatedController)
        }
        reviewController?.rootView?.activeControllerListner = {(activatedController) in
            self.activeControllerListner?(activatedController)
        }
        //doneController
        //activeControllerListner
    }
    
    func initializeVariable(){
                
        timeDateController?.rootView?.successHandler = {

            self.timeDateController?.rootView?.fillInfo(controller:self.chatController)
            self.chatController?.updateRootInfo()
            self.sessionPageDelegate?.updateChatTabUI()
            self.setChatInternalTab()
        }
       
        chatController?.rootView?.successHandler = {
            
            self.timeDateController?.rootView?.fillInfo(controller:self.chatController)
            self.chatController?.updateRootInfo()
            self.chatController?.rootView?.fillInfo(controller:self.reviewController)
            
            self.reviewController?.updateRootInfo()
            self.reviewController?.rootView?.fillInfo()
            
            self.sessionPageDelegate?.updateReviewTabUI()
            self.setReviewLaunchInternalTab()
        }
        
        reviewController?.rootView?.successHandler = {
          
            self.reviewController?.rootView?.passInfoToDoneController(controller:self.doneController)
            self.sessionPageDelegate?.successFullyCreatedEvent()
        }
       
        self.doneController?.delegate = self
    }
    
    private func setFirstController(){
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setReviewLaunchInternalTab(){
        
        setViewControllers([pages[2]], direction: .forward, animated: false, completion: nil)
        //accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    private func setChatInternalTab(){
        
        setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
        //accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    private func setDateTimeInternalTab(){
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        //accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    func setDateTab(){
        
        //should be call from the Session Controller
        sessionPageDelegate?.updateTimeDateTabUI()
        setDateTimeInternalTab()
    }
    
    func setChatTab(){
        
        timeDateController?.rootView?.switchTab()
    }
    
    func setReviewLaunchTab(){
        
        let _ = timeDateController?.rootView?.validateFields()
        chatController?.rootView?.switchTab()
        //accountDelegate?.contentOffsetForMemory(offset: 0.0)
    }
    
    func setDoneTab(){
        
        let _ = timeDateController?.rootView?.validateFields()
        let _ = chatController?.rootView?.validateFields()
        setViewControllers([pages[3]], direction: .forward, animated: false, completion: nil)
    }
    
    //    func timeDateNextAction(){
    //
    //        timeDateController?.rootView?.switchTab()
    //    }
    //
    //    func chatNextAction(){
    //
    //        chatController?.rootView?.nextAction(sender: nil)
    //    }
    //
    //    func reviewNextAction(){
    //
    //        reviewController?.rootView?.scheduleAction()
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

extension ScheduleSessionPageViewController:SessionDoneControllerProtocol{
    
    func backToAccount() {
        
        self.sessionPageDelegate?.backToMyAccount()
    }
}


