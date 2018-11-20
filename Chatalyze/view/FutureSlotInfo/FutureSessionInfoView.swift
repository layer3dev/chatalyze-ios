////
////  FutureSessionInfoView.swift
////  Chatalyze
////
////  Created by Mansa on 20/11/18.
////  Copyright © 2018 Mansa Infotech. All rights reserved.
////
//
//import Foundation
//
//class FutureSessionInfoView: ExtendedView {
//    
//    //Outlet for sessioninfo
//    
//    @IBOutlet var remaningTime:UILabel?
//    @IBOutlet var currentSlot:UILabel?
//    @IBOutlet var totalSlot:UILabel?
//    
//    override func viewDidLayout() {
//        super.viewDidLayout()
//        
//    }
//    
//    func showInfoForHost(info:SlotInfo?,slotCount:Int){
//        
//        guard let slotInfo = info else{
//            return
//        }
//        
//        guard let startDate = slot.startDate
//            else{
//                return
//        }
//        
//        guard let counddownInfo = startDate.countdownTimeFromNowAppended()
//            else{
//                return
//        }
//        
//    }
//    
//    
//    
//    private func updateNewHeaderInfoForSession(slot : SlotInfo){
//        
//        hostRootView?.callInfoContainer?.isHidden = true
//        sessionSlotView?.isHidden = false
//        
//        
//        
//        let slotCount = self.eventInfo?.mergeSlotInfo?.slotInfos?.count ?? 0
//        let currentSlot = (self.eventInfo?.mergeSlotInfo?.upcomingSlotInfo?.index ?? 0)
//        
//        var fontSize = 18
//        var remainingTimeFontSize = 20
//        if  UIDevice.current.userInterfaceIdiom == .pad{
//            fontSize = 24
//            remainingTimeFontSize = 26
//        }
//        
//        //Editing For the remaining time
//        
//        let timeRemaining = "\(counddownInfo.time)".toAttributedString(font: "Poppins", size: remainingTimeFontSize, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
//        
//        sessionRemianingTimeLbl?.attributedText = timeRemaining
//        
//        //Editing  for the current Chat
//        
//        let currentSlotText = "Chat \(currentSlot+1): "
//        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Questrial", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
//        
//        var username = ""
//        if let slotUserName = slot.user?.firstName{
//            username = slotUserName
//        }
//        
//        let slotUserNameAttrStr = username.toAttributedString(font: "Poppins", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
//        
//        currentMutatedSlotText.append(slotUserNameAttrStr)
//        sessionCurrentSlotLbl?.attributedText = currentMutatedSlotText
//        
//        //Editing for the total Chats
//        let totatlNumberOfSlotsText = "Total chats: "
//        let totalAttrText = totatlNumberOfSlotsText.toMutableAttributedString(font: "Questrial", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
//        
//        let totalSlots = "\(slotCount)".toAttributedString(font:"Poppins", size: fontSize, color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
//        
//        totalAttrText.append(totalSlots)
//        
//        sessionTotalSlotNumLbl?.attributedText = totalAttrText
//    }
//    
//}
