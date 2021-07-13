//
//  EarlyCallAlertController.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import NotificationCenter

class EarlyCallAlertController: InterfaceExtendedController {
    
    private let TAG = "EarlyCallAlertController"

    var requiredDate:Date?
    var info:EventInfo?
    var timer = Timer()
    @IBOutlet var minutes:UILabel?
    @IBOutlet var seconds:UILabel?
    @IBOutlet var name:UILabel?
    @IBOutlet var topArrowConstraint:NSLayoutConstraint?
    let eventDeletedListener = EventDeletedListener()
    let scheduleUpdateListener = ScheduleUpdateListener()
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.startTimer()
        self.fillInfo()
        self.startAnimation()
        self.scheduleUpdate()
        self.eventListener()
        self.initializeNotification()
    }
    
    func initializeNotification(){
    
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    

@objc func appMovedToBackground() {
    
    self.dismiss(animated: false) {
    }
    print("App moved to background!")
}
    
    func eventListener(){
        
        eventDeletedListener.setListener {(deletedEventID) in
            
            guard let id = self.info?.id else{
                return
            }
            if id == Int(deletedEventID ?? "0"){
                
                self.dismiss(animated: true, completion: {
                })
            }
        }
    }
    
    func scheduleUpdate(){
           scheduleUpdateListener.setListenerForNewStartDate { (eventInfoArray) in
               Log.echo(key: self.TAG, text: "\(eventInfoArray)")

               for info in eventInfoArray {
                   if ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) < 900 && ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) >= 0)) {

                       self.requiredDate = info.startDate
                       self.startTimer()
                   }else{
                       self.dismiss(animated: true) {
//                           RootControllerManager().getCurrentController()?.alert(withTitle: AppInfoConfig.appName, message: "Your session start time has been updated.", successTitle: "OK", rejectTitle: "", showCancel: false, completion: nil)
                       }
                   }
               }
           }
       }
    
    
    func startAnimation(){
        
        UIView.animate(withDuration: 0.5, animations: {
            if self.topArrowConstraint?.priority.rawValue == 250.0 {
                
                self.topArrowConstraint?.priority = UILayoutPriority(rawValue: 999.0)
                self.view.layoutIfNeeded()
                
            }else {
                
                self.topArrowConstraint?.priority = UILayoutPriority(rawValue: 250.0)
                self.view.layoutIfNeeded()
            }
            
        }){[weak self](success) in
            
            guard let weakSelf = self
                else{
                    return
            }
            
            if(weakSelf.isReleased){
                return
            }
            
            weakSelf.startAnimation()
        }
    }
    
    
    func fillInfo(){
        
        self.name?.text = info?.title
    }
    
    @IBAction func dismissAction(sender:UIButton?){
        
        self.dismiss(animated: true){
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    override func viewDidRelease() {
        super.viewDidRelease()
        
        Log.echo(key: TAG, text: "viewDidRelease")
        
        NotificationCenter.default.removeObserver(self)
        eventDeletedListener.releaseListener()
        self.timer.invalidate()
        
        
    }
    
    func startTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRepeat), userInfo: nil, repeats: true)
    }
    
    @objc func timerRepeat(){
        
        let (hour,minute,second) = countdownTimeFromNow(requiredDate: self.requiredDate) ?? ("","","")
        self.minutes?.text = minute
        self.seconds?.text = second
        
        Log.echo(key: "yud", text: "hour is \(hour) minute is \(minute) second is \(second)")
    }
    
    func countdownTimeFromNow(requiredDate:Date?)->( hours : String, minutes : String, seconds : String)?{
        
        guard let date = requiredDate else{
            return ("","","")
        }
        let totalSeconds = Int(date.timeIntervalTillNow)
        //print("logging", "total seconds ->  \(totalSeconds)")
        if totalSeconds > 900 || totalSeconds < 0{
            self.dismiss(animated: true) {
            }
            return("0","0","0")
        }
        let hours = (totalSeconds) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)
        return ( hourString, minuteString, secondString)
    }
    
    @IBAction func enterCallRoom(sender:UIButton?){
        
        guard let currentPresentingController = self.presentingViewController else{
            return
        }
            
        self.dismiss(animated: false) {
            
            DispatchQueue.main.async {
                let root = currentPresentingController
                self.validateVPN {
                    Log.echo(key: "EarlyCallController", text: "validate VPN response")
                    self.launchSession(currentPresentingController: root)
                }
                
            }
        }
    }
    
    private func validateVPN(completion : (()->())?){
        ValidateVPN().showVPNWarningAlert {
            completion?()
        }
    }
    
    private func launchSession(currentPresentingController : UIViewController){
        
        Log.echo(key: TAG, text: "launchSession")
        
        guard let controller = HostCallController.instance()
        else {
            return
        }
        controller.eventId = String(self.info?.id ?? 0)
        controller.callType = "green"
//        controller.callback = {
//            guard let controller = HostCallController.instance()
//            else {
//                return
//            }
//            controller.eventId = String(self.info?.id ?? 0)
//            Log.echo(key: "yud", text: "controller present is \(currentPresentingController)")
//            controller.modalPresentationStyle = .fullScreen
//            currentPresentingController.present(controller, animated: true, completion: nil)
//        }
        Log.echo(key: "yud", text: "controller present is \(currentPresentingController)")
        controller.modalPresentationStyle = .fullScreen
        currentPresentingController.present(controller, animated: true, completion: nil)
    }
    
    
}


extension EarlyCallAlertController{
    
    class func instance()->EarlyCallAlertController?{
        
        let storyboard = UIStoryboard(name: "EarlyEventAlert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EarlyCallAlert") as? EarlyCallAlertController
        return controller
    }
}
