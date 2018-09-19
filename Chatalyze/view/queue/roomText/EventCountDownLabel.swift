//
//  EventCountDownLabel.swift
//  Chatalyze
//
//  Created by Sumant Handa on 06/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventCountDownLabel: ExtendedLabel {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    
    
    func updateText(label : String, countdown : String){
        let size = CGFloat(26)
        let text = NSMutableAttributedString().appendCustom(label, size : size)
        text.appendCustom("\(countdown)", size : size, color : UIColor(hexString : AppThemeConfig.themeColor))
        self.attributedText = text
    }

}
