//
//  ExtendChatView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 04/03/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

class ExtendChatView: ExtendedView {
    

    @IBOutlet var extendBtnWidthAnchor: NSLayoutConstraint?
    
    @IBOutlet var extendLbl:UILabel?
    
    func showExtending(){
        extendLbl?.text = "Extending"
        self.isUserInteractionEnabled = false
        self.layoutIfNeeded()
    }
    
    func showExtend(){
        extendLbl?.text = "Extend"
        self.isUserInteractionEnabled = true
        self.layoutIfNeeded()
    }
    
    func hideExtendBtn(){
        // extend chat button to hide off before call get randered
        
        extendBtnWidthAnchor?.constant = 0
        roundCorners()
        self.layoutIfNeeded()
    }
    
    
    func showExtendBtn(){
        extendBtnWidthAnchor?.constant = 50
        self.layoutIfNeeded()
    }
    
    func roundCorners(){
        
        self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35 : 25
        self.clipsToBounds = true
    }

}

