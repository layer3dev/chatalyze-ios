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
    
    public func fillInfo(index : Int, slotInfo : SlotInfo?){
        self.slotInfo = slotInfo
        self.index = index
        fillInterface()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        registerForRefresh()
    }
    
    private func fillInterface(){
        
        queueNumberLabel?.text = "\((index ?? 0) + 1)"
        
        updateCountdownTime()
    }
    
    private func updateCountdownTime(){
        guard let slotInfo = slotInfo
            else{
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
        CountdownProcessor.sharedInstance().add {[weak self] in
            self?.updateCountdownTime()
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
        self.backgroundColor = UIColor(hexString: AppThemeConfig.greenColor)
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



