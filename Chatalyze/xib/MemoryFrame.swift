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
    
    @IBOutlet var widthOfStamp:NSLayoutConstraint?
    @IBOutlet var heightOfUserPic:NSLayoutConstraint?
    @IBOutlet var widthOfUserPic:NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        handleUI()
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
        widthOfStamp?.constant = 275
        name?.font = UIFont(name: "Nunito-Bold", size: 18)
        date?.font = UIFont(name: "Nunito-Bold", size: 18)
        memory?.font = UIFont(name: "Nunito-Regular", size: 15)
    }
    
    func setUIForLandscape(){
        
        heightOfUserPic?.constant = 45
        widthOfUserPic?.constant = 45
        widthOfStamp?.constant = 210
        name?.font = UIFont(name: "Nunito-Bold", size: 12)
        date?.font = UIFont(name: "Nunito-Bold", size: 12)
        memory?.font = UIFont(name: "Nunito-Regular", size: 11)
    }
}
