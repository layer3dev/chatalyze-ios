//
//  breakFeatureView.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class breakFeatureView : ExtendedView {

    @IBOutlet var headingLabel:UILabel?
    @IBOutlet var nextChatLabel:UILabel?
    @IBOutlet var timeLabel:UILabel?
    
    func startBreakShowing(time:String){
        
        headingLabel?.text = "BREAK"
        nextChatLabel?.text = "Next chat starts in: "
        timeLabel?.text = time
    }
    
    func disableBreakFeature(){
      
        headingLabel?.text = ""
        nextChatLabel?.text = ""
        timeLabel?.text = ""
    }
    
    
}
