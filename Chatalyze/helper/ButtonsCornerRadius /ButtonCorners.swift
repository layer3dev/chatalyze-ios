//
//  ButtonCorners.swift
//  Chatalyze
//
//  Created by Mansa on 29/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ButtonCorners:UIButton{
    
    var isLoaded = false
  
    override func layoutSubviews(){
     super.layoutSubviews()
        
        if isLoaded{
            return
        }
        paintInterface()
        isLoaded = true
        return
    }
    
    func paintInterface(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = true
            return
         }
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        return
    }
}
