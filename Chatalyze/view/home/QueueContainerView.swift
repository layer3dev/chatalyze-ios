//
//  QueueContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 23/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class QueueContainerView: ExtendedView {
    
    @IBOutlet var joinContainerView : JoinCountdownView?
    @IBOutlet var onGoingContainerView : OngoingEventView?
    @IBOutlet var waitContainerView : WaitCountdownView?
    @IBOutlet var noEventView : NoEventContainerView?
    
    var delegate : EventRefreshProtocol?
    
    var timer : EventTimer = EventTimer()
    var slotInfo : EventTimeProtocol?
    
    private var isQueueActive : Bool = false
    

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
        
        if(!(joinContainerView?.isHidden ?? true) ){
            _ = joinContainerView?.refresh()
        }
        
        if(!(waitContainerView?.isHidden ?? true) ){
            _ = waitContainerView?.refresh()
        }
        
        if(!(noEventView?.isHidden ?? true) ){
            
        }
    }
    
    
    func udpateView(callInfo : EventTimeProtocol?){
        self.slotInfo = callInfo
        refresh()
    }
    
    func processView(){
        
        hideAll()
        isQueueActive = false
        guard let slotInfo = slotInfo
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
        
        if(validator.isRoomEligible(start: startDate, end: endDate)){
//            Log.echo(key: "timer", text: "isPreConnectFuture")
            self.joinContainerView?.udpateTimer(slotInfo: slotInfo)
            isQueueActive = true
            return
        }
        
        if(startDate.isPast() && endDate.isFuture()){
//            Log.echo(key: "timer", text: "onGoingContainerView --> \(DateParser.dateToString(endDate))")
            self.onGoingContainerView?.showView()
            isQueueActive = true
            return
        }
        
        if(validator.isFutureEvent(start: startDate, end: endDate)){
//            Log.echo(key: "timer", text: "isFutureEvent")
            self.waitContainerView?.udpateTimer(slotInfo: slotInfo)
            isQueueActive = true
            return
        }
        
        if(isQueueActive){
            delegate?.refreshInfo()
            return
        }
        
        isQueueActive = false
        
        self.noEventView?.showView()
        return
    }
    
    func hideAll(){
        self.joinContainerView?.hideView()
        self.waitContainerView?.hideView()
        self.noEventView?.hideView()
        self.onGoingContainerView?.hideView()
    }

}
