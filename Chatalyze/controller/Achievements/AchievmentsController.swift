//
//  AchievmentsController.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Analytics

class AchievmentsController: InterfaceExtendedController {

    @IBOutlet var achievementAdapter:AchievementsAdapter?
    @IBOutlet var achievementImage:UIImageView?
    @IBOutlet var achievementText:UILabel?
    @IBOutlet var infoView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trackSegment()
        self.paintInterface()
        self.fetchInfo()
    }
    
    func trackSegment(){
        
        SEGAnalytics.shared().track("Attendee Achievements Page")
    }
    
    var chekpointsArray:[Bool] = [false,false,false,false,false,false,false,false,false,false]
    
    @IBAction func backAction(sender:UIButton?){     
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchInfo(){
        
        self.showLoader()
        FetchAchievementsProcessor().fetch { (success, error, response) in
            self.stopLoader()
            
            if !success{
                return
            }
            
            guard let infoArray = response?.array else{
                return
            }
            
            for info in infoArray {               
                
                if info["achievement"].stringValue == "BOOKED_FIRST_CHAT"{
                   
                    self.chekpointsArray[0] = true
                    continue
                }
                if info["achievement"].stringValue == "RECIEVED_FIRST_MEMORY"{
                    
                    self.chekpointsArray[1] = true
                    continue
                }
                if info["achievement"].stringValue == "SPONSORED_FIRST_SESSION"{
                    
                    self.chekpointsArray[2] = true
                    continue
                }
                if info["achievement"].stringValue == "FIRST_POST_CHAT_DONATION"{
                    
                    self.chekpointsArray[3] = true
                    continue
                }
                if info["achievement"].stringValue == "TWO_CHAT_WITH_SAME_HOST"{
                   
                    self.chekpointsArray[4] = true
                    continue
                }
                if info["achievement"].stringValue == "BOOKED_FIVE_CHATS"{
                    
                    self.chekpointsArray[5] = true
                    continue
                }
                if info["achievement"].stringValue == "SPONSORED_THREE_SESSIONS"{
                   
                    self.chekpointsArray[6] = true
                    continue
                }
                if info["achievement"].stringValue == "THIRD_POST_CHAT_DONATION"{
                    
                    self.chekpointsArray[7] = true
                    continue
                }
                if info["achievement"].stringValue == "BOOKED_TEN_CHATS"{
                   
                    self.chekpointsArray[8] = true
                    continue
                }
                if info["achievement"].stringValue == "BOOKED_TWENTY_CHATS"{
                    
                    self.chekpointsArray[9] = true
                    continue
                }
            }
            self.achievementAdapter?.updateAchievements(array:self.chekpointsArray)
        }
    }
    
    @IBAction func hideInfoAction(sender:UIButton?){
        
        self.hideInfoView()
    }
    
    func showInfoView(){
        
        UIView.animate(withDuration: 0.30) {
          
            self.infoView?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideInfoView(){
       
        UIView.animate(withDuration: 0.30) {
            
            self.infoView?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func handleActionOnClick(index:Int){
        
        self.showInfoView()
        if index == 0{
            
            if self.chekpointsArray[0] == true{
                
                self.achievementImage?.image = UIImage(named: "EmojiFirstTicketBooked")
                self.achievementText?.text = "Booked your first chat!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Booked your first chat!"
            return
        }
        if index == 1{
            
            if self.chekpointsArray[1] == true{
                
                self.achievementImage?.image = UIImage(named: "EmojiFirstMemory")
                self.achievementText?.text = "Received your first memory!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Received your first memory!"
            return
            
        }
        if index == 2 {
            
            if self.chekpointsArray[2] == true{
                
                self.achievementImage?.image = UIImage(named: "EmojiSponsoredOne")
                self.achievementText?.text = "Sponsored your first session!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Sponsored your first session!"
            return
        }
        if index == 3 {
            
            if self.chekpointsArray[3] == true {
                
                self.achievementImage?.image = UIImage(named: "EmojiFirstDonation")
                self.achievementText?.text = "Gave your first tip!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Gave your first tip!"
            return
        }
        if index == 4 {
            
            if self.chekpointsArray[4] == true {
                
                self.achievementImage?.image = UIImage(named: "EmojiTwoSameChat")
                self.achievementText?.text = "Booked 2 chats with the same host!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Booked 2 chats with the same host!"
            return
        }
        if index == 5 {
            
            if self.chekpointsArray[5] == true {
                
                self.achievementImage?.image = UIImage(named: "EmojiBookedFiveChats")
                self.achievementText?.text = "Booked 5 chats!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Booked 5 chats!"
            return
        }
        if index == 6 {
            
            if self.chekpointsArray[6] == true {
                
                self.achievementImage?.image = UIImage(named: "EmojiSponsoredThree")
                self.achievementText?.text = "Sponsored 3 sessions!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Sponsored 3 sessions!"
            return
        }
        if index == 7 {
            
            if self.chekpointsArray[7] == true{
                
                self.achievementImage?.image = UIImage(named: "EmojiThreeDonation")
                self.achievementText?.text = "Gave 3 tips!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Gave 3 tips!"
            return
        }
        if index == 8 {
            
            if self.chekpointsArray[8] == true {
                
                self.achievementImage?.image = UIImage(named: "EmojiTenTicketsBooked")
                self.achievementText?.text = "Booked 10 chats!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Booked 10 chats!"
            return
        }
        if index == 9 {
            
            if self.chekpointsArray[9] == true{
                
                self.achievementImage?.image = UIImage(named: "EmojiTwentyChats")
                self.achievementText?.text = "Booked 20 chats!"
                return
            }
            self.achievementImage?.image = UIImage(named: "EmojiLock")
            self.achievementText?.text = "Booked 20 chats!"
            return
        }
    }
    
    
    func paintInterface(){
        
        self.hideNavigationBar()
        self.paintHideBackButton()
        self.achievementAdapter?.controller = self
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func jumpToScroller(){
        
        guard let controller = AchievementImageController.instance() else{
            return
        }
        controller.showingImage = self.achievementImage?.image
        controller.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(controller, animated: true, completion: {
        })
    }
    
    
    class func instance()->AchievmentsController?{
        
        let storyboard = UIStoryboard(name: "Achievements", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Achievments") as? AchievmentsController
        return controller
    }
    
}
