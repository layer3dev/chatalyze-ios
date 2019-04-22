//
//  AchievementsCollectionCell.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class AchievementsCollectionCell: ExtendedCollectionCell {
    
    var isAchieved:Bool = false
    var currentIndex:Int = 0
    var root:AchievementsAdapter?  
    @IBOutlet var myImage:UIImageView?
    
    func fillInfo(isAchieved:Bool,currentIndex:Int){
        
        self.isAchieved = isAchieved
        self.currentIndex = currentIndex
        handleAcheievementImage()
    }
    
    func handleAcheievementImage() {
        
        Log.echo(key: "yud", text: "Current index is \(self.currentIndex) and the isAchieved is \(self.isAchieved)")
        
        if currentIndex == 0{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiFirstTicketBooked")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 1{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiFirstMemory")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 2{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiSponsoredOne")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 3{
            
            if isAchieved == true {
               
                self.myImage?.image = UIImage(named: "EmojiFirstDonation")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 4{
            if isAchieved == true {
                
                self.myImage?.image = UIImage(named: "EmojiTwoSameChat")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
        }
        if currentIndex == 5 {
            
            if isAchieved == true {
                
                self.myImage?.image = UIImage(named: "EmojiBookedFiveChats")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 6{
            
            if isAchieved == true {
                
                self.myImage?.image = UIImage(named: "EmojiSponsoredThree")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 7{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiThreeDonation")
               
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 8{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiTenTicketsBooked")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
        if currentIndex == 9{
            
            if isAchieved == true{
                
                self.myImage?.image = UIImage(named: "EmojiTwentyChats")
                return
            }
            self.myImage?.image = UIImage(named: "EmojiLock")
            return
        }
    }
    
    @IBAction func tapOnCellAction(sender:UIButton){
        
        root?.controller?.handleActionOnClick(index: self.currentIndex)
    }
}
