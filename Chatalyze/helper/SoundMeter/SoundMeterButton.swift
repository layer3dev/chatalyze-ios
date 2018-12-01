//
//  SoundMeterButton.swift
//  Chatalyze
//
//  Created by Mansa on 18/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SoundMeterButton: UIButton {
    
    var isLayout = false
    override func layoutSubviews() {
        
        if isLayout{
         return
        }
        isLayout = true
        paintInterface()
    }
    func paintInterface(){
        
        self.layer.borderColor = UIColor(hexString: "#CBCBCB").cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
}
