//
//  ScheduleSessionController.swift
//  Chatalyze
//
//  Created by Mansa on 29/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionController: InterfaceExtendedController {

    var pageViewController:ScheduleSessionPageViewController?
    
    @IBOutlet var timeDateLbl:UILabel?
    @IBOutlet var timeDateImg:UIImageView?
    
    @IBOutlet var chatLbl:UILabel?
    @IBOutlet var chatImg:UIImageView?
    
    @IBOutlet var reviewLbl:UILabel?
    @IBOutlet var reviewImg:UIImageView?
    
    @IBOutlet var internalView:UIView?
    @IBOutlet var progressBar: UIProgressView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeTapGesture()
        paintInterface()
    }
    
    
    func paintInterface(){
 
        paintBackButton()
        paintNavigationTitle(text: "Schedule Session")
        handleTransitions()
    }
    
    func handleTransitions(){
        
        pageViewController?.sessionPageDelegate = self
    }
    
//    func initializeVariable(){
//
//        timeDateController?.rootView?.successHandler = {
//            self.timeDateController?.rootView?.fillInfo(controller:self.chatController)
//            self.setChatInternalTab()
//        }
//        chatController?.rootView?.successHandler = {
//            self.chatController?.rootView?.fillInfo(controller:self.reviewController)
//            self.setReviewLaunchInternalTab()
//        }
//        reviewController?.rootView?.successHandler = {
//
//        }
//    }
    
    
    
    
    
    func initializeTapGesture(){
        
        let setDateTimeGesture = UITapGestureRecognizer(target: self, action: #selector(self.setDateTimeTab))
        setDateTimeGesture.delegate = self
        self.timeDateLbl?.addGestureRecognizer(setDateTimeGesture)
        timeDateImg?.addGestureRecognizer(setDateTimeGesture)
        
        let setChatTabGesture = UITapGestureRecognizer(target: self, action: #selector(setChatTab))
        
        setChatTabGesture.delegate = self
        chatLbl?.addGestureRecognizer(setChatTabGesture)
        chatImg?.addGestureRecognizer(setChatTabGesture)
        
        let setReviewLaunchGesture = UITapGestureRecognizer(target: self, action: #selector(setReviewLaunchTab))
        setReviewLaunchGesture.delegate = self
        reviewLbl?.addGestureRecognizer(setReviewLaunchGesture)
        reviewImg?.addGestureRecognizer(setReviewLaunchGesture)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let segueIdentifier  = segue.identifier
        if segueIdentifier == "session"{
            
            pageViewController = segue.destination as? ScheduleSessionPageViewController
           // pageViewController?.accountDelegate = self
           // pageViewController?.ticketController?.featureHeight = containerView?.bounds.size.height ?? 0.0
        }
    }
    
    @objc func setReviewLaunchTab(){

        pageViewController?.setReviewLaunchTab()
    }
    
    @objc func setChatTab(){
  
        Log.echo(key: "yud", text: "I am callling setChatTab")
        pageViewController?.setChatTab()
    }
    
    @objc func setDateTimeTab(){
        
        Log.echo(key: "yud", text: "I am callling setDateTimeTab")
        pageViewController?.setDateTab()        
        
    }
    
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

extension ScheduleSessionController{
    
    class func instance()->ScheduleSessionController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ScheduleSession") as? ScheduleSessionController
        return controller
    }
}

extension ScheduleSessionController:ScheduleSessionPageInterface{
    
    func updateTimeDateTabUI(){
        
        //self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.progressBar?.progress = 0.0
            self.view.layoutIfNeeded()
        }){ (success) in
            
        }
    }
    func updateChatTabUI(){
       
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            self.progressBar?.progress = 0.5
            self.view.layoutIfNeeded()
        }){ (success) in
            
        }
    }
    func updateReviewTabUI(){
      
        UIView.animate(withDuration: 1, animations: {
            self.progressBar?.progress = 1
            self.view.layoutIfNeeded()
        }){ (success) in
            
        }
    }
    func successFullyCreatedEvent(){
        
        Log.echo(key: "yud", text: "Event has been successfully created!!")
    }
}
