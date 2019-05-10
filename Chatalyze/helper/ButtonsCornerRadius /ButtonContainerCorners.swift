//
//  ButtonContainerCorners.swift
//  Chatalyze
//
//  Created by Mansa on 29/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ButtonContainerCorners:UIView{
    
    var isLoaded = false
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if isLoaded{
            return
        }
        isLoaded = true
        paintInterface()
        return
    }
    
    
    func paintInterface(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            self.layer.cornerRadius = 6
            //self.layer.masksToBounds = true
            return
        }
        self.layer.cornerRadius = 4
        //self.layer.masksToBounds = true
        return
    }
}

