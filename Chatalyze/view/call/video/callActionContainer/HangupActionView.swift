//
//  HangupActionView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HangupActionView: ExtendedView {

    @IBOutlet var actionImage : UIImageView?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    func activate(){
       
        actionImage?.image = UIImage(named : "activate_hangup")
    }
    
    func deactivate(){
       
        actionImage?.image = UIImage(named : "deactivate_hangup")
    }

}
