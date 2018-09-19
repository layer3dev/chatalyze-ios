//
//  EventSlotNumberLabel.swift
//  Chatalyze
//
//  Created by Sumant Handa on 02/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class EventSlotNumberLabel: ExtendedLabel {

    private var _slotNumber : Int?
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
    
    var slotNumber : Int{
        get{
            return _slotNumber ?? 0
        }
        set{
            _slotNumber = newValue
            updateText()
        }
    }
    
    
    
    private func updateText(){
        if(slotNumber == 0){
            let size = CGFloat(26)
            let text = NSMutableAttributedString().appendCustom("Your chat is finished", size : size)
            self.attributedText = text
            return
        }
        let size = CGFloat(26)
        let text = NSMutableAttributedString().appendCustom("You have Chat Number ", size : size)
        text.appendCustom("\(slotNumber)", size : size, color : UIColor(hexString : AppThemeConfig.themeColor))
        self.attributedText = text
    }

}
