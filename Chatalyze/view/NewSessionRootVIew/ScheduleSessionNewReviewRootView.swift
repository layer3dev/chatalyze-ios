//
//  ScheduleSessionNewReviewRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionNewReviewRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
    func scheduleSession()
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
    
    override func viewDidLayout() {
        super.viewDidLayout()
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
        
        self.priceLbl?.text = "$"+"\(String(describing: info.price ?? 0))"
        self.isSelfieLbl?.text = info.isScreenShotAllow ? "YES":"NO"
        dateLbl?.text = getDate()
        timeLbl?.text = getTime()
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
        param["isFree"] = false
        param["screenshotAllow"] = info.isScreenShotAllow ? "\(info.screenShotParam)": ""
        Log.echo(key: "yud", text: "PARAMS ARE \(param)")
        return param
    }
    
    
    
    @IBAction func scheduleAction(sender:UIButton?){
        
        delegate?.goToNextScreen()
        return
        
        self.resetErrorlabel()
        let isThisFutureTime = self.isThisFutureTime()
        if !isThisFutureTime {
            self.showError(message: "Please select the future time")
            return
        }        
        if selectedImage != nil{
            //scheduleActionWithImage()
            return
        }
        delegate?.scheduleSession()
    }
    
    //
    //    private func uploadImage(completion : ((_ success : Bool, _ info : JSON?)->())?){
    //
    //        guard let image = self.controller?.selectedImage else{
    //            return
    //        }
    //        guard let data = image.jpegData(compressionQuality: 1.0)
    //            else{
    //                completion?(false, nil)
    //                return
    //        }
    //
    //        self.paramForUpload["eventBannerInfo"] = true
    //        Log.echo(key: "imageUploading", text: "The parameteres that I am sending is \(paramForUpload)")
    //        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
    //        self.paramForUpload["eventBanner"] = imageBase64
    //
    //        var requiredParamForUpload = paramForUpload
    //        requiredParamForUpload["selectedHourSlot"] = nil
    //
    //
    //        //For inserting the paragraph
    //        let paraText = requiredParamForUpload["description"] as? String
    //        let ParaArray = paraText?.components(separatedBy: "\n")
    //
    //        var requiredStr = ""
    //        for info in ParaArray ?? []{
    //            requiredStr = requiredStr+"<p>"+info+"</p>"
    //        }
    //        requiredParamForUpload["description"] = requiredStr
    //
    //        Log.echo(key: "yud", text: " \nRequired param sending to web \(requiredParamForUpload)")
    //
    //        self.controller?.showLoader()
    //        resetErrorlabel()
    //        SessionRequestWithImageProcessor().schedule(params: requiredParamForUpload) { [weak self] (success, info) in
    //
    //            Log.echo(key: "yud", text: "Response in succesful event creation is \(String(describing: info))")
    //
    //            self?.controller?.stopLoader()
    //            completion!(success,info)
    //            if !success{
    //                self?.showError(message: info?["message"].stringValue ?? "")
    //                return
    //            }
    //        }
    //    }
    //
    //    func scheduleActionWithImage(){
    //
    //        uploadImage { (success, response) in
    //
    //            if !success{
    //                return
    //            }
    //
    //            if let info = response{
    //                let eventInfo = EventInfo(info: info)
    //                self.eventInfo = eventInfo
    //            }
    //
    //            Log.echo(key: "imageUploading", text: "Image uploading result is \(success) and the response is \(self.param)")
    //
    //            if let handler = self.successHandler{
    //                handler()
    //            }
    //        }
    //    }
    
    
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
