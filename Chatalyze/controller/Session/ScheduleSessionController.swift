//
//  ScheduleSessionController.swift
//  Chatalyze
//
//  Created by Mansa on 29/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ScheduleSessionController: InterfaceExtendedController {
    
    var activatedController = CurrentControllerFlag.DateTimeController
    var activeControllerListner:((CurrentControllerFlag?)->())?
    
    var pageViewController:ScheduleSessionPageViewController?
    
    @IBOutlet var timeDateLbl:UILabel?
    @IBOutlet var timeDateImg:UIImageView?
    
    @IBOutlet var chatLbl:UILabel?
    @IBOutlet var chatImg:UIImageView?
    
    @IBOutlet var reviewLbl:UILabel?
    @IBOutlet var reviewImg:UIImageView?
    
    @IBOutlet var internalView:UIView?
    @IBOutlet var progressBar: UIProgressView?
    
    @IBOutlet var doneImg:UIImageView?
    
    var delegate:ScheduleSessionDelegate?
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintBackButton()
        paintSettingButton()
    }
    
    func initializeVariable(){
        
        pageViewController?.activeControllerListner = {(activatedController) in
            
            Log.echo(key:"yud",text:"ctivatedController is \(activatedController.rawValue)")
            self.activatedController = activatedController
        }
    }
    
    @IBAction func backButtonAction(sender:UIButton?){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func goToPreviousController(sender:UIButton?){
        
        if self.activatedController ==  CurrentControllerFlag.DateTimeController{
          
            self.navigationController?.popViewController(animated: true)
            return
        }
        if self.activatedController ==  CurrentControllerFlag.ChatController{
           
            pageViewController?.setDateTab()
            return
        }
        if self.activatedController ==  CurrentControllerFlag.LandingController{
            
            pageViewController?.setChatTab()
            return
        }        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        paintNavigationTitle(text: "Schedule Session")
        initializeTapGesture()
        paintInterface()
        hideNavigationBar()
        initializeVariable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar()
    }
    
    
    func paintInterface(){
 
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
            //pageViewController?.accountDelegate = self
            //pageViewController?.ticketController?.featureHeight = containerView?.bounds.size.height ?? 0.0
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
   
    func backToMyAccount() {
        
        self.navigationController?.popToRootViewController(animated: true)
        //delegate?.navigateToMySession()
    }
    
    func updateTimeDateTabUI(){
        
        //self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            
            self.progressBar?.progress = 0.0
            self.view.layoutIfNeeded()
        }){ (success) in
            
            self.chatImg?.image = UIImage(named: "whiteCircle")
            self.reviewImg?.image = UIImage(named: "whiteCircle")
        }
    }
    func updateChatTabUI(){
       
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations: {
            
            self.progressBar?.progress = 0.33
            self.chatImg?.image = UIImage(named: "circle")
            self.view.layoutIfNeeded()
        }){ (success) in
            self.reviewImg?.image = UIImage(named: "whiteCircle")
        }
    }
    func updateReviewTabUI(){
      
        UIView.animate(withDuration: 1, animations: {
            
            self.progressBar?.progress = 0.66
            self.chatImg?.image = UIImage(named: "circle")
            self.reviewImg?.image = UIImage(named: "circle")
            self.view.layoutIfNeeded()
        }){ (success) in
            
            self.chatImg?.image = UIImage(named: "circle")
            self.reviewImg?.image = UIImage(named: "circle")
        }
    }
    
    func updateDoneTabUI(){
        
        UIView.animate(withDuration: 1, animations: {
            
            self.progressBar?.progress = 1.0
            self.doneImg?.image = UIImage(named: "circle")
            self.reviewImg?.image = UIImage(named: "circle")
            self.view.layoutIfNeeded()
        }){ (success) in
        }
    }
    
    func successFullyCreatedEvent(){
        
        self.internalView?.isUserInteractionEnabled = false
        Log.echo(key: "yud", text: "Event has been successfully created!!")
        updateDoneTabUI()
        pageViewController?.doneController?.eventInfo = pageViewController?.reviewController?.rootView?.eventInfo
        pageViewController?.setDoneTab()
    }
}


extension ScheduleSessionController{
    
    enum CurrentControllerFlag:Int{
    
        case DateTimeController = 0
        case ChatController = 1
        case LandingController = 2
    }
}
