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
    @IBOutlet var eventQueueView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        verifyForEventDelay()
        eventScheduleUpdatedAlert()
        delayAlert()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func verifyForEventDelay(){
        
        guard let slotInfo = slotInfo else{
            return
        }
        
        //Verifying that event is delayed or not started yet
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "" ) == ""){
            
            showAlertMessage()
            statusLbl?.text = "Session has not started yet."
            return
        }
        
        if ((slotInfo.started ?? "") == "") && ((slotInfo.notified ?? "") == "delayed"){
            
            showAlertMessage()
            statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
            return
        }
    }
    
    func eventScheduleUpdatedAlert(){
        
        updatedEventScheduleListner.callScheduleId = String(slotInfo?.callscheduleId ?? 0)
        updatedEventScheduleListner.setListener {
            self.hideAlertMessage()
            //self.loadInfoFromServer(showLoader : false)
            self.loadInfoFromServerAfterScheduleUpdate(showLoader: true, completion: {(success) in
                if success{
                    Log.echo(key: "yud", text: "I am refreshing successfully")
                    self.refresh()
                }
            })
        }
    }
    
    
    func delayAlert(){
        
        eventDelayListener.callScheduleId = String(slotInfo?.callscheduleId ?? 0)
        
        eventDelayListener.setListener {
            
            Log.echo(key: "yud", text: "Yes the event is delayed")
            self.showAlertMessage()
            self.statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
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
        
        guard let evInfo = eventInfo
            else{
                return
        }
        
        //Verifying that event is delayed or not started yet
        Log.echo(key: "yud", text: "valid slot started is \(evInfo.started)")
        Log.echo(key: "yud", text: "valid slot notified is \(evInfo.notified)")
        
        
        if ((evInfo.started ?? "") == "") && ((evInfo.notified ?? "" ) == ""){
            
            showAlertMessage()
            statusLbl?.text = "Session has not started yet."
            return
        }
        
        if ((evInfo.started ?? "") == "") && ((evInfo.notified ?? "") == "delayed"){
            
            showAlertMessage()
            statusLbl?.text = "This event has been delayed. Please stay tuned for an updated start time."
            return
        }
        
        guard let slotInfo = eventInfo?.myValidSlot.slotInfo
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
