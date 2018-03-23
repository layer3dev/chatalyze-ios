//
//  QueueContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class QueueContainerView: ExtendedView {
    
    @IBOutlet var jointContainerView : JoinCountdownView?
    @IBOutlet var waitContainerView : WaitCountdownView?
    @IBOutlet var noEventView : NoEventContainerView?
    
    var timer : EventTimer = EventTimer()
    
    
    var eventInfo : EventInfo?
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        registerForPing()
    }
    
    func registerForPing(){
         timer.startTimer(withInterval: 1.0)
        timer.ping {
            self.refresh()
        }
    }
    
    private func refresh(){
        processView()
        
        if(!(jointContainerView?.isHidden ?? true) ){
            _ = jointContainerView?.refresh()
        }
        
        if(!(waitContainerView?.isHidden ?? true) ){
            _ = waitContainerView?.refresh()
        }
        
        if(!(noEventView?.isHidden ?? true) ){
            
        }
        
        
    }
    
    
    func udpateView(eventInfo : EventInfo?){
        self.eventInfo = eventInfo
        refresh()
    }
    
    func processView(){
        hideAll()
        guard let slotInfo = eventInfo?.callschedule
            else{
                self.noEventView?.showView()
                return
        }
        
        guard let startDate = slotInfo.startDate
            else{
                self.noEventView?.showView()
                return
        }
        
        guard let endDate = slotInfo.endDate
            else{
                self.noEventView?.showView()
                return
        }
        
        
        let validator = EventValidator()
        
        if(validator.isPreConnectEligible(start: startDate, end: endDate)){
            
            self.jointContainerView?.udpateTimer(eventInfo: eventInfo)
            return
        }
        
        if(validator.isFutureEvent(start: startDate, end: endDate)){
            self.waitContainerView?.udpateTimer(eventInfo: eventInfo)
            return
        }
        self.noEventView?.showView()
        return
    }
    
    func hideAll(){
        self.jointContainerView?.hideView()
        self.waitContainerView?.hideView()
        self.noEventView?.hideView()
    }

}
