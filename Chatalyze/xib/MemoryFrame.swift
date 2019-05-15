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
        
        guard let inPortrait = isPortraitInSize else{
            return
        }        
        if inPortrait{
            setUIForPortrait()
            return
        }
        setUIForLandscape()
    }
    
    func setUIForPortrait(){
        
        heightOfUserPic?.constant = 63
        widthOfUserPic?.constant = 63
        widthOfStamp?.constant = 255
        stickerLeading?.constant = 6
        stickerBottom?.constant = 6
        name?.font = UIFont(name: "Nunito-Bold", size: 18)
        date?.font = UIFont(name: "Nunito-Bold", size: 15)
        memory?.font = UIFont(name: "Nunito-Regular", size: 13)
    }
    
    func setUIForLandscape(){
        
        heightOfUserPic?.constant = 36
        widthOfUserPic?.constant = 36
        widthOfStamp?.constant = 165
        stickerLeading?.constant = 3
        stickerBottom?.constant = 3
        name?.font = UIFont(name: "Nunito-Bold", size: 11)
        date?.font = UIFont(name: "Nunito-Bold", size: 9)
        memory?.font = UIFont(name: "Nunito-Regular", size: 8)
    }
}
