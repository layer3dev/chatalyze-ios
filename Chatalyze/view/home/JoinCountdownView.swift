//
//  JoinCountdownView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class JoinCountdownView: ExtendedView {

    
    @IBOutlet private var minuteLabel : UILabel?
    @IBOutlet private var secondLabel : UILabel?
    
    var timer : EventTimer = EventTimer()
    var eventInfo : EventInfo?
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
    
    func udpateTimer(eventInfo : EventInfo?){
        self.eventInfo = eventInfo
        timer.startTimer(withInterval: 1.0)
        timer.ping {
            let isValid = self.refresh()
        }
    }
    
    private func refresh()->Bool{
        guard let slotInfo = eventInfo?.callschedule
            else{
                return false
        }
        guard let startDate = slotInfo.startDate
            else{
                return false
        }
        
        
        Log.echo(key: "timer", text: "startDate --> \(DateParser.dateToStringInServerFormat(startDate))")
        let time = Int(startDate.timeIntervalSinceNow)
        
        let minutes = (time / 60)
        let seconds = (time % 60)
        
        minuteLabel?.text = String("\(minutes ?? 0)")
        secondLabel?.text = String("\(seconds ?? 0)")
        
        
        return true
    }
    
    

}
