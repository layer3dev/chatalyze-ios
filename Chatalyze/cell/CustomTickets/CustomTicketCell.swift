//
//  CustomTicketCell.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 06/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

class CustomTicketCell: ExtendedTableCell {

    
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
    
    
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    var discriptiontext : String?
    var checkinTime : String?
    
    
      
    func fillInfo(info:CustomTicketsInfo?){
        
        guard let info = info else{
            return
        }
        
       
        self.info = info
        checkInTime(time: info.start! ?? "")
        initializeDesiredDatesFormat(info: info)
        self.eventNamelbl?.text = info.title
        self.hostNameLbl?.text = info.hostName
        self.selectionStyle = .none
    }
    
    @IBAction func claimTicket(send:UIButton?){
        delegate?.claimTicket(info: PurchaseTicketRequest())
    }
    
    
    func initializeDesiredDatesFormat(info:CustomTicketsInfo){
        _formattedEndTime = info.end
        _formattedStartTime = info.start
        self.eventStartDate?.text = self.formattedStartDate
        self.discriptionLbl?.text = getDiscriptionForSlot(with: formattedStartTime, endTime: formattedEndTime)
     
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
    

    func getDiscriptionForSlot(with startTime : String?,endTime : String?)-> String?{
        
        if let date = DateParser.UTCStringToDate(info?.start ?? "") {
            
            if date.timeIntervalSince(Date()) > 1800.0{
                disableClaimBtn()
                return self.slotInfoBeforeCheckIn(withStartTime: startTime ?? "", endTime: endTime ?? "")
                
            }else{
                enableClaimBtn()
                return self.slotInfoAfterCheckIn(withStartTime: startTime ?? "", andEndTime: endTime ?? "")
            }
        }
        return "fefefefef"
    }
    
    
    func slotInfoBeforeCheckIn(withStartTime  startTime: String, endTime : String) -> String?{
        
        var discriptiontext : String?
        
        
  
        discriptiontext = "Your check-in time is from \(checkinTime ?? "") - \(formattedStartTime ?? ""). Please note that failure to check in on time may result in loss of your spot.\n\n Upon check in, you will receive a specific time between \(formattedStartTime ?? "") and \(formattedEndTime ?? "") for your meet and greet. \n\n To check in, visit this page during your check-in time and follow the prompt that will become visible only during this time."
        
        
        return discriptiontext
    }
    
    
    func slotInfoAfterCheckIn(withStartTime startTime : String?,andEndTime endTime : String) -> String{
        var discription : String?
        
        discription = "Claim your ticket to meet\(info?.hostName ?? "").Upon claiming your ticket, you will receive a specific time between \(startTime ?? "") and \(endTime) for your meet and greet."
        return discription ?? ""
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
            self.claimButtonhight?.constant = 85
        }else{
            self.claimButtonhight?.constant = 65
        }
    }
  
}
