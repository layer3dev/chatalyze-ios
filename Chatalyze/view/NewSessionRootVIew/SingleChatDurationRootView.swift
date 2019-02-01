//
//  SingleChatDurationRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SingleChatDurationRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class SingleChatDurationRootView:ExtendedView {
    
    var delegate:SingleChatDurationRootViewDelegate?
    enum slotDurationMin:Int{
        
        case two = 0
        case three = 1
        case five = 2
        case ten = 3
        case fifteen = 4
        case thirty = 5
        case none = 6
    }
    
    @IBOutlet var twoMinutesBtn:UIButton?
    @IBOutlet var threeMinutesBtn:UIButton?
    @IBOutlet var fiveMinutesBtn:UIButton?
    @IBOutlet var tenMinutesBtn:UIButton?
    @IBOutlet var fifteenMinutesBtn:UIButton?
    @IBOutlet var thirtyMinutesBtn:UIButton?
    
    var slotSelected:slotDurationMin = .none
    @IBOutlet var slotDurationErrorLbl:UILabel?
    @IBOutlet var chatCalculatorLbl:UILabel?
    @IBOutlet var chatTotalNumberOfSlots:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func paintRootWithExistingData(){
        
        paintChatCalculator()
    }
    
    
    func resetDurationSelection(){
        
        twoMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        threeMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        fiveMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        tenMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        fifteenMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        thirtyMinutesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
    }
    
    @IBAction func chatSlotDurationAction(sender:UIButton){
        
        if sender.tag == 0 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .two
        }
        else if sender.tag == 1 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .three
        }
        else if sender.tag == 2 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .five
        }
        else if sender.tag == 3 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .ten
        }
        else if sender.tag == 4 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .fifteen
        }
        else if sender.tag == 5 {
            
            resetDurationSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.slotSelected = .thirty
        }
        paintChatCalculator()
        let _ = validateSlotTime()
    }
    
    
    var chatDuration:Int?{
        
        get{
            
            if slotSelected == .none{
                return nil
            }
            if slotSelected == .two{
                return 2
            }
            if slotSelected == .three{
                return 3
            }
            if slotSelected == .five{
                return 5
            }
            if slotSelected == .ten{
                return 10
            }
            if slotSelected == .fifteen{
                return 15
            }
            if slotSelected == .thirty{
                return 30
            }
            return nil
        }
    }
    
    
    @IBAction func nextAction(sender:UIButton?){
        
        if(!validateFields()){
            self.resetErrorStatus()
        }
        updateParamter()
        delegate?.goToNextScreen()
    }
    
    func updateParamter(){
        delegate?.getSchduleSessionInfo()?.duration = chatDuration
    }
}


extension SingleChatDurationRootView {
    
    func paintChatCalculator(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        guard let startDate = info.startDateTime else{
            return
        }
        guard let endDate = info.endDateTime else{
            return
        }
        
        let totalDurationInMinutes = Int(endDate.timeIntervalSince(startDate)/60.0)
        
        var totalSlots = 0
        
        guard let singleChatDuration = chatDuration else{
            return
        }
        
        totalSlots = totalDurationInMinutes/singleChatDuration
        
        var fontSizeTotalSlot = 30
        var normalFont = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            fontSizeTotalSlot = 26
            normalFont = 18
        }
        
        if totalSlots > 0 && totalDurationInMinutes > 0 && singleChatDuration > 0{
            
            Log.echo(key: "yud", text: "Slot number fetch SuccessFully \(totalSlots) and the totalMinutesOfChat is \(totalDurationInMinutes) and the single Chat is \(singleChatDuration)")
            
            chatCalculatorLbl?.text = "\(totalDurationInMinutes) min session length / \(singleChatDuration) min chat length ="
            
            let mutableStr  = "\(totalSlots)".toMutableAttributedString(font: "Poppins", size: fontSizeTotalSlot, color: UIColor(hexString: "#FAA579"), isUnderLine: false)
            
            let nextStr = " available 1:1 chats"
            let nextAttrStr  = nextStr.toAttributedString(font: "Questrial", size: (normalFont-3), color: UIColor(hexString: "#9a9a9a"), isUnderLine: false)
            
            mutableStr.append(nextAttrStr)
            chatTotalNumberOfSlots?.attributedText = mutableStr
        }
        Log.echo(key: "yud", text: "total number of the slot is \(totalSlots)")
    }
    
    func resetErrorStatus(){
        
        slotDurationErrorLbl?.text = ""
    }
    
    func validateFields()->Bool{
        
        let durationValidated = validateSlotTime()
        return  durationValidated
    }
    
    fileprivate func validateSlotTime()->Bool{
        
        if(slotSelected == .none){
            
            slotDurationErrorLbl?.text = "Chat duration is required."
            return false
        }
        slotDurationErrorLbl?.text = ""
        return true
    }
    
    func showError(message:String?){
        //errorLbl?.text =  message ?? ""
    }
}




