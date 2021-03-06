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
    let timezone = TimeZone.current.abbreviation()
    var expiryTime : String?
    var counter = 0
    var timer : Timer?
    var controller : MyTicketsVerticalRootView?
    private let scheduleUpdateListener = ScheduleUpdateListener()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        registerForListener()

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
    var endCheckinTime : String?
    var endTimeToChedkin : String?
    var sessionId : Int?
    var dateFormate: String? = String()
    var timeFortmate : String? = String()
    
    
    func getLangSupoortedDateFormat(){
        if Locale.current.languageCode == "en"{
            dateFormate = "EEE, MMM dd, yyyy"
            timeFortmate = "h:mm a"
        } else if Locale.current.languageCode == "zh" {
            dateFormate = "yyyy 年 MM 月 d 日"
            timeFortmate = "下午 h 點 mm 分"
        } else if Locale.current.languageCode == "ko" {
            dateFormate = "MM월 d일"
            timeFortmate = "h:mm a"
        }else{
            dateFormate = "dd/MM/yyyy"
            timeFortmate = Locale.current.languageCode == "th" ? "H.mm" : "H:mm"
        }
        
    }
      
    func fillInfo(info:CustomTicketsInfo?){
        
        guard let info = info else{
            return
        }
        
       
        self.info = info
        getLangSupoortedDateFormat()
        checkInTime(time: info.start ?? "")
        endCheckInTime(time: info.start ?? "")
        initializeDesiredDatesFormat(info: info)
        self.eventNamelbl?.text = info.title
        self.hostNameLbl?.text = "Hosted By : " + "\(info.hostName ?? "")"
        self.sessionId = info.room_id
        self.selectionStyle = .none
        rootAdapter?.root?.controller?.noTicketLbl?.isHidden = true
        rootAdapter?.root?.controller?.noTicketLbl?.isHidden = true
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
        _expiryTime = info.start
        self.eventStartDate?.text = self.formattedStartDate
        self.discriptionLbl?.attributedText = getDiscriptionForSlot(with: formattedStartTime, endTime: formattedEndTime)

    }
    
    
    var _formattedStartTime:String?{
        get{
            return formattedStartTime ?? ""
        }
        set{
            
            let date = newValue
            if Locale.current.languageCode == "ko" {
                if let time = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss a") {
                    if time.contains("AM") {
                        timeFortmate = "오전 h시 mm분"
                    } else {
                        timeFortmate = "오후 h시 mm분"
                    }
                }
            }
            formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: timeFortmate)
            formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: dateFormate)
        }
    }
    
    var _formattedEndTime:String?{
        
        get{
            
            return formattedEndTime ?? ""
        }
        set{
            
            let date = newValue
            if Locale.current.languageCode == "ko" {
                if let time = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss a") {
                    if time.contains("AM") {
                        timeFortmate = "오전 h시 mm분"
                    } else {
                        timeFortmate = "오후 h시 mm분"
                    }
                }
            }
            formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: timeFortmate)
        }
    }
    
    var _expiryTime : String?{
        get{
            return expiryTime ?? ""
        }
        
        set{
            let startDate = DateParser.UTCStringToDate(info?.start ?? "") ?? Date()
            let calender = Calendar.current
            let newDate = calender.date(byAdding: .minute, value: -120, to: startDate) ?? Date()
            let diffence = newDate.timeIntervalSince(Date())
            Log.echo(key: "timeDiffence", text: "\(diffence)")
            counter = Int(diffence)
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            
        }
    }
    
    @objc func runTimer(){
        if counter > 0{
            counter -= 1
            Log.echo(key: "TIMER", text: "RUnning TIMER....\(counter)")
            return
        }
        if counter == 0 && timer != nil {
            Log.echo(key: "Reloaded Cell", text: "table need to reload")
            rootAdapter?.root?.controller?.fetchCustomTickets()
            timer?.invalidate()
            timer = nil
        }
            
        
    }
    

    func getDiscriptionForSlot(with startTime : String?,endTime : String?)-> NSAttributedString?{
        
        if let date = DateParser.UTCStringToDate(info?.start ?? "") {
            
            if date.timeIntervalSince(Date()) > 3600.0{
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
        
        
        let part1 = NSAttributedString(string: "Your check-in time is from ".localized() ?? "")
        let checkInTimeInfo = "\(checkinTime ?? "") " + "- \(endCheckinTime ?? "")" + " \(timezone ?? "")"
        
        let text = "\(checkInTimeInfo). \("Please note that failure to check in on time may result in loss of your spot.".localized() ?? "")"

        let eventStartTimeinfo = "\(formattedStartTime ?? "" )" + (" and".localized() ?? "") + " \(formattedEndTime ?? "")" + " \(timezone ?? "")"
        
        let text3 = (" Upon check in, you will receive a specific time between ".localized() ?? "") + "\(eventStartTimeinfo)" + (" for your meet and greet. \n\n To check in, visit this page during your check-in time and follow the prompt that will become visible only during this time.".localized() ?? "")
        
        var part2 = NSAttributedString(string: text)
         part2 =  text.toAttributedString(font: AppThemeConfig.boldFont, size: 14, color: .black, isUnderLine: false)
        
        
        let part3 = NSAttributedString(string: text3)
        
        let combination = NSMutableAttributedString()
        combination.append(part1)
        combination.append(part2)
        combination.append(part3)
        
        return combination
    }
    
    func registerForListener(){
        scheduleUpdateListener.setListener {
            
            self.rootAdapter?.root?.controller?.fetchCustomTickets()
        }
    }
    
    
    func slotInfoAfterCheckIn(withStartTime startTime : String?,andEndTime endTime : String) -> NSAttributedString{
        var discription : String?
        
        let eventStartTime = "\(startTime ?? "" )" +  (" and".localized() ?? "") + " \(endTime )" + " \(timezone ?? "")"
        
        discription = "\("Claim your ticket to meet Host :".localized() ?? "") \(info?.hostName ?? ""). \("Upon claiming your ticket, you will receive a specific time between".localized() ?? "") \(eventStartTime) \("for your meet and greet.".localized() ?? "")"
        
        
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
        let newDate = calender.date(byAdding: .minute, value: -60, to: checkInDate)
        
        guard let formatedChkecin = DateParser.dateToString(newDate, requiredFormat: timeFortmate ?? "") else{
            return
        }
    
        checkinTime = formatedChkecin
    }
    
    func endCheckInTime(time: String){
        
        guard let checkInDate = DateParser.stringToDate(time) else{
            return
        }
        let calender = Calendar.current
        let newDate = calender.date(byAdding: .minute, value: -30, to: checkInDate)
        
        if Locale.current.languageCode == "ko" {
            if let time = DateParser.dateToString(newDate, requiredFormat: timeFortmate ?? "") {
                if time.contains("AM") {
                    timeFortmate = "오전 h시 mm분"
                } else {
                    timeFortmate = "오후 h시 mm분"
                }
            }
        }
        guard let formatedChkecin = DateParser.dateToString(newDate, requiredFormat: timeFortmate ?? "") else{
            return
        }
    
        endCheckinTime = formatedChkecin
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

