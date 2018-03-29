//
//  JoinCountdownView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class WaitCountdownView: ZeroHeightView {
    
    @IBOutlet private var hourLabel : UILabel?
    @IBOutlet private var minuteLabel : UILabel?
    @IBOutlet private var secondLabel : UILabel?
    
    var slotInfo : EventTimeProtocol?
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    
    func udpateTimer(slotInfo : EventTimeProtocol?){
        self.showView()
        
        self.slotInfo = slotInfo
        
    }
    
    func refresh()->Bool{
        guard let slotInfo = slotInfo
            else{
                return false
        }
        guard let startDate = slotInfo.startDate
            else{
                return false
        }
        
        
        guard let counddownInfo = startDate.countdownTimeFromNow()
            else{
                return false
        }
        
        hourLabel?.text = counddownInfo.hours
        minuteLabel?.text = counddownInfo.minutes
        secondLabel?.text = counddownInfo.seconds
        
        return true
    }
    
    
}
