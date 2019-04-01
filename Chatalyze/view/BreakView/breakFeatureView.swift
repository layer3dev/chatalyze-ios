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
    
    func startBreakShowing(){
        
        headingLabel?.text = ""
        nextChatLabel?.text = ""
        timeLabel?.text = ""
    }
    
    func disableBreakFeture(){
      
        headingLabel?.text = ""
        nextChatLabel?.text = ""
        timeLabel?.text = ""
    }
    
    
}
