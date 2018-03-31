//
//  EventStartCountdownLabel.swift
//  Chatalyze
//
//  Created by Sumant Handa on 31/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventStartCountdownLabel: ExtendedLabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    
    private func initialization(){
        guard let role = SignedUserInfo.sharedInstance?.role
            else{
                return
        }
        
        if(role == .analyst){
            self.text = "Event will begin in"
        }else{
            self.text = "Your chat will begin in"
        }
    }

}
