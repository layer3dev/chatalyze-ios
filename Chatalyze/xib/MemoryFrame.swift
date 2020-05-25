//
//  MemoryFrame.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit


class MemoryFrame:XibTemplate{
    
    @IBOutlet var screenShotPic:UIImageView?
    @IBOutlet var memoryStickerView : MemoryStickerView?
    
    @IBOutlet var name:UILabel?
    @IBOutlet var date:UILabel?
    @IBOutlet var memory:UILabel?
    @IBOutlet var userPic:UIImageView?
    var isPortraitInSize:Bool?
    @IBOutlet var stickerView:UIView?
    
    @IBOutlet var widthOfStamp:NSLayoutConstraint?
    @IBOutlet var heightOfUserPic:NSLayoutConstraint?
    @IBOutlet var widthOfUserPic:NSLayoutConstraint?
    
    @IBOutlet var stickerLeading:NSLayoutConstraint?
    @IBOutlet var stickerBottom:NSLayoutConstraint?

    @IBOutlet var analystImageLeading:NSLayoutConstraint?
    @IBOutlet var analystImageTop:NSLayoutConstraint?
    @IBOutlet var analystImageBottom:NSLayoutConstraint?

    @IBOutlet var userNameLead:NSLayoutConstraint?
    @IBOutlet var userNameTrail:NSLayoutConstraint?
    @IBOutlet var dateTrail:NSLayoutConstraint?
    @IBOutlet var dateLead:NSLayoutConstraint?
    @IBOutlet var memoryTrail:NSLayoutConstraint?
    @IBOutlet var memoryLead:NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        paintInterface()
        handleUI()
    }
    
    func paintInterface(){
        
        userPic?.layer.cornerRadius = 4
        userPic?.layer.masksToBounds = true
        
        stickerView?.layer.cornerRadius = 4
        stickerView?.layer.masksToBounds = true
        
    }
    
    func handleUI(){
        
        guard let inPortrait = isPortraitInSize else {
            return
        }        
        if inPortrait{
            setUIForPortrait()
            return
        }
        setUIForLandscape()
    }
    
    func setUIForPortrait(){
        
        heightOfUserPic?.constant = 80
        widthOfUserPic?.constant = 80
        stickerLeading?.constant = 10
        stickerBottom?.constant = 10
        
        analystImageLeading?.constant = 10
        analystImageTop?.constant = 10
        analystImageBottom?.constant = 10
        
        userNameLead?.constant = 10
        userNameTrail?.constant = 10
        
        dateTrail?.constant = 10
        dateLead?.constant = 10
        
        memoryTrail?.constant = 10
        memoryLead?.constant = 10
        
        name?.font = UIFont(name: "Nunito-Bold", size: 24)
        date?.font = UIFont(name: "Nunito-Bold", size: 20)
        memory?.font = UIFont(name: "Nunito-Bold", size: 15)
    }
    
    func setUIForLandscape(){
        
        heightOfUserPic?.constant = 120
        widthOfUserPic?.constant = 120

        stickerLeading?.constant = 13
        stickerBottom?.constant = 13
                
        analystImageLeading?.constant = 13
        analystImageTop?.constant = 13
        analystImageBottom?.constant = 13
        
        userNameLead?.constant = 13
        userNameTrail?.constant = 13
        
        dateTrail?.constant = 13
        dateLead?.constant = 13
        
        memoryTrail?.constant = 13
        memoryLead?.constant = 13
        
        name?.font = UIFont(name: "Nunito-Bold", size: 34)
        date?.font = UIFont(name: "Nunito-Bold", size: 28)
        memory?.font = UIFont(name: "Nunito-Bold", size: 20)
    }
}
