//
//  ClaimTicketCell.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 29/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

class ClaimTicketCell: ExtendedTableCell {
    
    
    var info:CustomTicketsInfo?
    var rootAdapter:MyTicketesVerticalAdapter?
    var delegate:MyTicketCellDelegate?
    var startTime : Date?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
       
        
    }
    
    @IBOutlet  weak var eventNamelbl : UILabel?
    @IBOutlet  weak var hostNameLbl : UILabel?
    @IBOutlet  weak var eventStartDate : UILabel?
    @IBOutlet  weak var discriptionLbl : UILabel?
    @IBOutlet weak var claimButtonhight: NSLayoutConstraint?
    @IBOutlet weak var borderView : UIView?
    
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    var discriptiontext : String?
    var checkinTime : String?
    var sessionId : Int?
    
    
      
    func fillInfo(info:CustomTicketsInfo?){
        
        guard let info = info else{
            return
        }
        
       
        self.info = info
        checkInTime(time: info.start ?? "")
        initializeDesiredDatesFormat(info: info)
        self.eventNamelbl?.text = info.title
        self.hostNameLbl?.text = info.hostName
        self.sessionId = info.room_id
        self.selectionStyle = .none
    }
    
    @IBAction func claimTicket(send:UIButton?){
        
        guard  let userid =  SignedUserInfo.sharedInstance?.id else {
            Log.echo(key: "ClaimTicket", text: "User id is missing")
            return
        }
        let request = PurchaseTicketRequest(sessionid: sessionId ?? Int(), userId: Int(userid), date: Data())
        delegate?.claimTicket(info: request)
    }
    
    
    func initializeDesiredDatesFormat(info:CustomTicketsInfo){
        _formattedEndTime = info.end
        _formattedStartTime = info.start
        self.eventStartDate?.text = self.formattedStartDate
        self.discriptionLbl?.attributedText = getDiscriptionForSlot(with: formattedStartTime, endTime: formattedEndTime)

    }
    
    
    var _formattedStartTime:String?{
        get{
            return formattedStartTime ?? ""
        }
        set{
            
            let date = newValue
            formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
            formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EEE, MMM dd, yyyy")
        }
    }
    
    var _formattedEndTime:String?{
        
        get{
            
            return formattedEndTime ?? ""
        }
        set{
            
            let date = newValue
            formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
        }
    }
    

    func getDiscriptionForSlot(with startTime : String?,endTime : String?)-> NSAttributedString?{
        
        if let date = DateParser.UTCStringToDate(info?.start ?? "") {
            
            if date.timeIntervalSince(Date()) > 1800.0{
                disableClaimBtn()
              
                return self.slotInfoBeforeCheckIn(withStartTime: startTime ?? "", endTime: endTime ?? "")
                
            }else{
                enableClaimBtn()
                return self.slotInfoAfterCheckIn(withStartTime: startTime ?? "", andEndTime: endTime ?? "")
            }
        }
        return NSAttributedString()
    }
    
    
    func slotInfoBeforeCheckIn(withStartTime  startTime: String, endTime : String) -> NSAttributedString?{
        
        
        let part1 = NSAttributedString(string: "Your check-in time is from ")
        
        let text = "\(checkinTime ?? "") - \(formattedStartTime ?? ""). Please note that failure to check in on time may result in loss of your spot.\n\n "
        
        let text2 = "Upon check in, you will receive a specific time between \(formattedStartTime ?? "") and \(formattedEndTime ?? "") for your meet and greet. \n\n. To check in, visit this page during your check-in time and follow the prompt that will become visible only during this time."
        
        let text3 = "Upon check in, you will receive a specific time between \(formattedStartTime ?? "") and \(formattedEndTime ?? "") for your meet and greet. \n\n. To check in, visit this page during your check-in time and follow the prompt that will become visible only during this time."
        
        var part2 = NSAttributedString(string: text)
         part2 =  text.toAttributedString(font: AppThemeConfig.boldFont, size: 14, color: .black, isUnderLine: false)
        
        
        let part3 = NSAttributedString(string: text3)
        
        let combination = NSMutableAttributedString()
        combination.append(part1)
        combination.append(part2)
        combination.append(part3)
        
        return combination
    }
    
    
    func slotInfoAfterCheckIn(withStartTime startTime : String?,andEndTime endTime : String) -> NSAttributedString{
        var discription : String?
        
        discription = "Claim your ticket to meet \(info?.hostName ?? ""). Upon claiming your ticket, you will receive a specific time between \(startTime ?? "") and \(endTime) for your meet and greet."
        let attText = NSAttributedString(string: discription ?? "")
        
        let mutableText = NSMutableAttributedString()
        mutableText.append(attText)
        return mutableText
    }
    
    
    func checkInTime(time: String){
        
        guard let checkInDate = DateParser.stringToDate(time) else{
            return
        }
        let calender = Calendar.current
        let newDate = calender.date(byAdding: .minute, value: -30, to: checkInDate)
        
        let formatedChkecin = DateParser.dateToString(newDate, requiredFormat: "h:mm a")
    
        checkinTime = formatedChkecin
    }
    
    
    func disableClaimBtn(){
        self.claimButtonhight?.constant = 0
    }
    
    func enableClaimBtn(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.claimButtonhight?.constant = 65
        }else{
            self.claimButtonhight?.constant = 50
        }
        
    }
  
}

struct PurchaseTicketRequest {
    var sessionid : Int?
    var userId : Int?
    var date: Data?
}

