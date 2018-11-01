//
//  UserEventQueueController.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserEventQueueController: EventQueueController {
    
    @IBOutlet var statusLbl:UILabel?
    @IBOutlet var scrollView:UIScrollView?
    let updatedEventScheduleListner = UpdateEventListener()
    let eventDelayListener = EventDelayListener()
    let analystJoinedListener  = AnalystJoinedAndScheduleUpdatedListener()
    
    @IBOutlet var eventQueueView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //verifyForEventDelay()
        analystJoinedNotification()
        eventNotificationListener()
        delayNotificationListener()
    }
    
    func analystJoinedNotification(){
        
        analystJoinedListener.setListener {
            
            self.hideAlertMessage()
            self.loadInfoFromServer(showLoader: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    func showAlertMessage(){
        
        scrollView?.isHidden = true
        eventQueueView?.isHidden = true
        statusLbl?.isHidden = false
    }
    
    
    func hideAlertMessage(){
        
        scrollView?.isHidden = false
        eventQueueView?.isHidden = false
        statusLbl?.isHidden = true
    }
    
//    private func verifyForEventDelay(){
//
//        guard let slotInfo = slotInfo else{
//            return
//        }
//
//        //Verifying that event is delayed or not started yet
//        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "" ) == ""){
//
//            showAlertMessage()
//            statusLbl?.text = "Session has not started yet."
//            return
//        }
//
//        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "") == "delayed"){
//
//            showAlertMessage()
//            statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
//            return
//        }
//    }
    
    func eventNotificationListener(){

        updatedEventScheduleListner.setListener {
            
            self.hideAlertMessage()
            self.loadInfoFromServer(showLoader: true)
        }
    }
    
    
    func delayNotificationListener(){
        
        eventDelayListener.setListener {
       
            self.loadInfoFromServer(showLoader: true)

//            Log.echo(key: "yud", text: "Yes the event is delayed")
//            self.showAlertMessage()
//            self.statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
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
    
    override func refresh(){
        super.refresh()
        
        //Verifying that event is delayed or not started yet
     
//        Log.echo(key: "user_socket", text: "valid slot started in refresh \(eventInfo?.started)")        
//        Log.echo(key: "user_socket", text: "valid slot notified in refresh \(eventInfo?.notified)")
        
        guard let eventInfo = eventInfo
            else{
                return
        }
        
        if ((eventInfo.started ?? "") == "") && ((eventInfo.notified ?? "" ) == ""){
            
            showAlertMessage()
            statusLbl?.text = "Session has not started yet."
            return
        }
        
        if ((eventInfo.started ?? "") == "") && ((eventInfo.notified ?? "") == "delayed"){
            
            showAlertMessage()
            statusLbl?.text = "This session has been delayed. Please stay tuned for an updated start time."
            return
        }
        
        if ((eventInfo.started ?? "") != "") && ((eventInfo.notified ?? "") == "schedule_updated"){
            
            self.hideAlertMessage()
        }
        
        self.hideAlertMessage()
        guard let slotInfo = eventInfo.myValidSlot.slotInfo
            else{
                return
        }
        
        if(slotInfo.isWholeConnectEligible){
         
            guard let controller = UserCallController.instance()
                else{
                    return
            }
            
            guard let eventId = self.eventInfo?.id
                else{
                    return
            }
            controller.eventInfo = eventInfo
            controller.eventId = "\(eventId)"
            timer.pauseTimer()
            
            self.navigationController?.present(controller, animated: true, completion: {
                
            self.navigationController?.popViewController(animated: false)
            })
        }
    }
}

