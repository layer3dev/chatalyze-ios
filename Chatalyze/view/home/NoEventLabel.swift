//
//  NoEventLabel.swift
//  Chatalyze
//
//  Created by Sumant Handa on 22/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class NoEventLabel: ExtendedLabel {

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
        let size = CGFloat(26)
        let text = NSMutableAttributedString().appendCustom("No", size : size)
        text.appendCustom(" Event", size : size, color : UIColor(hexString : AppThemeConfig.greenColor))
        text.appendCustom(" Booking.", size : size)
        
        self.attributedText = text
    }

}
