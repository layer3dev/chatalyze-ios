//
//  SessionReviewRootView.swift
//  Chatalyze
//
//  Created by Mansa on 24/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SessionReviewRootView:ExtendedView{
    
    
    @IBOutlet var titleLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var durationLbl:UILabel?
    @IBOutlet var slotDurationLbl:UILabel?
    @IBOutlet var priceLbl:UILabel?
    @IBOutlet var isSelfieLbl:UILabel?
    @IBOutlet var errorLabel:UILabel?
    var eventInfo:EventInfo?
    
    var param = [String:Any]()
    var controller:SessionReviewController?
    var successHandler:(()->())?
    var totalDurationOfEvent:Int = 0
    var editedParam = [String:Any]()
    var paramForUpload = [String:Any]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func mergeEditedtoRealParam(){
        
        //Param meters edited in the editScheduleController is merging
        for (key,value) in editedParam{
            self.param[key] = value
        }
    }
    
    func fillInfo(){
        
        Log.echo(key: "yud", text: "param is \(param)")
        
        mergeEditedtoRealParam()
        titleLbl?.text = param["title"] as? String
        
        if let duration = param["duration"] as? Int{
            
            self.slotDurationLbl?.text = "\(duration) mins"
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.thirtyMin{
            
            self.durationLbl?.text = "30 mins"
            totalDurationOfEvent = 30
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.oneHour{
           
            self.durationLbl?.text = "1 hour"
            totalDurationOfEvent = 60
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.twohour{
            
            self.durationLbl?.text = "2 hours"
            totalDurationOfEvent = 120
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.oneAndhour{
           
            self.durationLbl?.text = "1.5 hours"
            totalDurationOfEvent = 90
        }
        if let price = param["price"] as? String{
            
            self.priceLbl?.text = "$"+"\(price)"
        }
        if let screenShot = param["screenshotAllow"] as? String{
            
            self.isSelfieLbl?.text = "YES"
        }else{
           
            self.isSelfieLbl?.text = "NO"
        }
        dateLbl?.text = getDate()
        timeLbl?.text = getTime()
    }
    
    func getDate()->String{
        
        if let date = self.param["start"] as? String{
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let newdate = dateFormatter.date(from: date) {
                
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "EEEE-MMM-dd , yyyy"
                return dateFormatter.string(from: newdate)
            }
            return ""
        }
        return ""
    }
    func getTime()->String{
        
        if let date = self.param["start"] as? String{
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let newdate = dateFormatter.date(from: date) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: newdate)
            }
            return ""
        }
        return ""
    }
    
    @IBAction func scheduleAction(sender:UIButton?){
      
        paramForUpload = self.param
      
        Log.echo(key: "imageUploading", text: "The parameteres that I am sending is \(paramForUpload)")
        
        guard let hourlyPrice = caluclateHourlyPrice() else {
            return
        }
        
        paramForUpload["price"] = hourlyPrice
        
        if controller?.selectedImage != nil{
            scheduleActionWithImage()
            return
        }
        
        scheduleAction()
    }
    
    
    private func uploadImage(completion : ((_ success : Bool, _ info : JSON?)->())?){
        
        guard let image = self.controller?.selectedImage else{
            return
        }
        guard let data = UIImageJPEGRepresentation(image, 1.0)
            else{
                completion?(false, nil)
                return
        }
        self.paramForUpload["eventBannerInfo"] = true
        Log.echo(key: "imageUploading", text: "The parameteres that I am sending is \(paramForUpload)")
        let imageBase64 = "data:image/png;base64," +  data.base64EncodedString(options: .lineLength64Characters)
        self.paramForUpload["eventBanner"] = imageBase64
        self.controller?.showLoader()
        resetErrorlabel()
        SessionRequestWithImageProcessor().schedule(params: paramForUpload) { [weak self] (success, info) in
            
            Log.echo(key: "yud", text: "Response in succesful event creation is \(info)")
            
            self?.controller?.stopLoader()
            completion!(success,info)
            if !success{
                return
            }
        }
    }
    
    func scheduleActionWithImage(){
        
        uploadImage { (success, response) in
            
            if !success{
                return
            }
            
            if let info = response{
                let eventInfo = EventInfo(info: info)
                self.eventInfo = eventInfo
            }
            
            Log.echo(key: "imageUploading", text: "Image uploading result is \(success) and the response is \(self.param)")
            
            if let handler = self.successHandler{
                handler()
            }
        }
    }
    
    
    func resetErrorlabel(){
        
        self.errorLabel?.text = ""
    }
    
    func showError(message:String = ""){
     
        self.errorLabel?.text = message
    }
    
    func caluclateHourlyPrice()->String?{
     
        if let duration = param["duration"] as? Int{
            let hourlySlots = (60/duration)
            if let singleChatPriceStr = param["price"] as? String{
                if let singleChatPrice = Int(singleChatPriceStr){
                    let hourlyPrice = (singleChatPrice*hourlySlots)
                    return "\(hourlyPrice)"
                }
            }
        }
        return nil
    }
    
    func scheduleAction(){
      
        self.paramForUpload["eventBannerInfo"] = false
        self.controller?.showLoader()
        resetErrorlabel()
        Log.echo(key: "yud", text: "Param sending to web \(paramForUpload)")
        
        ScheduleSessionRequest().save(params: paramForUpload) { (success, message, response) in
         
            Log.echo(key: "yud", text: "Response in succesful event creation is \(response)")
            
            self.controller?.stopLoader()
            
            if !success{
                self.showError(message:message)
                return
            }
            
            if let info = response{
                let eventInfo = EventInfo(info: info)
                self.eventInfo = eventInfo
            }
            
            if let handler = self.successHandler{
                handler()
            }
            
//            guard let controller = SessionDoneController.instance() else{
//                return
//            }
//            self.controller?.navigationController?.pushViewController(controller, animated:true)
        }
        
    }
    
    func passInfoToDoneController(controller:SessionDoneController?){
        
        guard let controller = SessionDoneController.instance() else{
            return
        }
        controller.eventInfo = self.eventInfo
        controller.fillParam(param:self.param)
    }
}
