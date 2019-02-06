//
//  ScheduleSessionNewReviewRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ScheduleSessionNewReviewRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
    func scheduleSession()
    func goToEditScheduleSession()
}

class ScheduleSessionNewReviewRootView: ExtendedRootView {
    
    var delegate:ScheduleSessionNewReviewRootViewDelegate?
    @IBOutlet var titleLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var durationLbl:UILabel?
    @IBOutlet var slotDurationLbl:UILabel?
    @IBOutlet var priceLbl:UILabel?
    @IBOutlet var isSelfieLbl:UILabel?
    @IBOutlet var errorLabel:UILabel?
    private var selectedImage:UIImage?
    
    @IBOutlet var chatPupView:ButtonContainerCorners?
    @IBOutlet var nextView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintLayers()
    }
    
    func paintLayers(){
        
        self.nextView?.layer.masksToBounds = true
        self.nextView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.nextView?.layer.borderWidth = 1
        self.nextView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        self.chatPupView?.layer.masksToBounds = true
        self.chatPupView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.chatPupView?.layer.borderWidth = 1
        self.chatPupView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
    }
    func fillInfo(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        
        titleLbl?.text = info.title
        self.slotDurationLbl?.text = "\(String(describing: info.duration ?? 0)) mins"
        
        if info.totalTimeInMinutes ?? 0 == 30{
            self.durationLbl?.text = "30 mins"
        }
        if info.totalTimeInMinutes ?? 0 == 60{
            
            self.durationLbl?.text = "1 hour"
        }
        if info.totalTimeInMinutes ?? 0 == 120{
            
            self.durationLbl?.text = "2 hours"
        }
        if info.totalTimeInMinutes ?? 0 == 90{
            
            self.durationLbl?.text = "1.5 hours"
        }
        
        self.priceLbl?.text = (info.price ?? 0)  == 0 ? "Free":("$"+"\(String(describing: info.price ?? 0))")
        self.isSelfieLbl?.text = info.isScreenShotAllow ? "YES":"NO"
        dateLbl?.text = getDate()
        timeLbl?.text = "\(getTime()) \(String(describing: TimeZone.current.abbreviation() ?? ""))"
    }
    
    func getDate()->String{
        
        if let date = delegate?.getSchduleSessionInfo()?.startDateTime {
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE, MMM. dd, yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func getTime()->String{
        
        if let date = self.delegate?.getSchduleSessionInfo()?.startDateTime{
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    
    func isThisFutureTime()->Bool{
        
        if let startTime = delegate?.getSchduleSessionInfo()?.startDateTime{
            
            Log.echo(key: "yud", text: "Time Interval till now is \(startTime.timeIntervalTillNow)")
            if startTime.timeIntervalTillNow > 0{
                return true
            }
            return false
        }
        return false
    }
    
    
    func getParam()->[String:Any]?{
        
        //        {"start":"2019-02-07T19:30:00+05:30","end":"2019-02-07T20:30:00+05:30","userId":36,"duration":15,"price":88,"isFree":false,"eventFeedbackInfo":null,"youtubeURL":null,"emptySlots":null,"screenshotAllow":"automatic"}
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return nil
        }
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return nil
        }
        
        guard let startDate = info.startDateTime else{
            return nil
        }
        
        guard let endDate = info.endDateTime else{
            return nil
        }
        
        guard let durate = info.duration else{
            return nil
        }
        
        guard let priceHourly = caluclateHourlyPrice() else{
            return nil
        }
        
        var param = [String:Any]()
        
        param["title"] = info.title
        param["start"] = "\(startDate)"
        param["end"] = "\(endDate)"
        param["userId"] = id
        param["duration"] = durate
        param["price"] = priceHourly
        param["isFree"] = info.isFree
        param["screenshotAllow"] = info.isScreenShotAllow == true ? info.screenShotParam:nil
        param["description"] = info.eventDescription
        param["eventBannerInfo"] = info.bannerImage == nil ? false:true
        Log.echo(key: "yud", text: "PARAMS ARE \(param)")
        return param
    }
    
    //MARK:- Button Action
    @IBAction func editSchecduleAction(sender:UIButton?){
        delegate?.goToEditScheduleSession()
    }
    
    @IBAction func scheduleAction(sender:UIButton?){
        
        self.resetErrorlabel()
        let isThisFutureTime = self.isThisFutureTime()
        if !isThisFutureTime {
            self.showError(message: "Please select the future time")
            return
        }        
        if selectedImage != nil{
            delegate?.scheduleSession()
            return
        }
        delegate?.scheduleSession()
    }
    
    
    func resetErrorlabel(){
        self.errorLabel?.text = ""
    }
    
    func showError(message:String = ""){
        self.errorLabel?.text = message
    }
    
    func caluclateHourlyPrice()->String?{
        
        if let duration = delegate?.getSchduleSessionInfo()?.duration{
            let hourlySlots = (60/duration)
            if let singleChatPriceStr = delegate?.getSchduleSessionInfo()?.price{
                let hourlyPrice = (singleChatPriceStr*hourlySlots)
                return "\(hourlyPrice)"
            }
        }
        return nil
    }
}
