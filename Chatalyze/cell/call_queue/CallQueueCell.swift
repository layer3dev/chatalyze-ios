//
//  CallQueueCell.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit
import ImageLoader

class CallQueueCell: ExtendedCollectionCell {
    
    fileprivate var index : Int?
    fileprivate var slotInfo : SlotInfo?
    @IBOutlet private var queueNumberLabel : UILabel?
    @IBOutlet private var countdownLabel : UILabel?
    var adapterListener : CallQueueInterface?
    private var countdownIndex : Int = 0
    var countdownListener : CountdownListener?
    private var isRegisteredForRefresh = false
    
    public func fillInfo(index : Int, slotInfo : SlotInfo?, countdownListener : CountdownListener?){
      
        self.slotInfo = slotInfo
        self.index = index
        self.countdownListener = countdownListener
        fillInterface()
        registerForRefresh()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        
    }
    
    private func fillInterface(){
        
        guard let slotInfo = slotInfo
            else{
                return
        }
        
        if let slotNo = slotInfo.slotNo{
            queueNumberLabel?.text = "\(slotNo)"
        }
        
        
        updateCountdownTime()
    }
    
    private func updateCountdownTime(){
        guard let slotInfo = slotInfo
            else{
                return
        }
        
        if(slotInfo.isBreak){
            countdownLabel?.text = "Break"
            return
        }
        
        guard let startDate = slotInfo.startDate
            else{
                return
        }
        
        guard let endDate = slotInfo.endDate
            else{
                return
        }
        
        updateBackgroundColor()
        
        let targetDate = startDate.isFuture() ? startDate : endDate
        
        guard let countdownInfo = targetDate.countdownTimeFromNow()
            else{
                return
        }
        if(!countdownInfo.isActive){
            countdownLabel?.text = "Finished"
            return
        }
        
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
        countdownLabel?.text = countdownTime
    }
    
    private func registerForRefresh(){
        if(isRegisteredForRefresh){
            return
        }
        isRegisteredForRefresh = true
        countdownListener?.add {[weak self] in
            self?.updateCountdownTime()
            if(self?.adapterListener?.isInstanceReleased() ?? false){
                let countdownIndex = self?.countdownIndex ?? 0
                CountdownProcessor.sharedInstance().release(identifier: countdownIndex)
                return
            }
        }
    }
    
    private func updateBackgroundColor(){
        guard let role = SignedUserInfo.sharedInstance?.role
            else{
                return
        }
        
        if(role == .analyst){
            updateBackgroundForHost()
            return
        }
        
        updateBackgroundForUser()
    }
    
    private func updateBackgroundForHost(){
        guard let slotInfo = slotInfo
            else{
                return
        }
        
        if(slotInfo.isLIVE){
            markActive()
        }else{
            markIdeal()
        }
    }
    
    private func updateBackgroundForUser(){
        
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        guard let slotInfo = slotInfo
            else{
                return
        }
        
        guard let slotUserId = slotInfo.user?.id
            else{
                return
        }
        
        if(selfId == slotUserId){
            markActive()
            return
        }
        
        if(slotInfo.isLIVE){
            markSecondaryActive()
            return
        }
        
        markIdeal()
        
    }
    
    private func markActive(){
        
        self.backgroundColor = UIColor(hexString: AppThemeConfig.themeColor)
        self.countdownLabel?.textColor = UIColor.white
        self.queueNumberLabel?.textColor = UIColor.white
    }
    
    private func markIdeal(){
        
        self.backgroundColor = UIColor.white
        self.countdownLabel?.textColor = UIColor(hexString: AppThemeConfig.idealGray)
        self.queueNumberLabel?.textColor = UIColor(hexString: AppThemeConfig.idealGray)
    }
    
    private func markSecondaryActive(){
        
        self.backgroundColor = UIColor(hexString: AppThemeConfig.idealGray)
        self.countdownLabel?.textColor = UIColor.white
        self.queueNumberLabel?.textColor = UIColor.white
    }
}



