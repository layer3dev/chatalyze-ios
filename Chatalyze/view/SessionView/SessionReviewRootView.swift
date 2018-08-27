//
//  SessionReviewRootView.swift
//  Chatalyze
//
//  Created by Mansa on 24/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionReviewRootView:ExtendedView{
    
    @IBOutlet var titleLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var durationLbl:UILabel?
    @IBOutlet var slotDurationLbl:UILabel?
    @IBOutlet var priceLbl:UILabel?
    @IBOutlet var isSelfieLbl:UILabel?
    @IBOutlet var errorLabel:UILabel?
    
    var param = [String:Any]()
    var controller:SessionReviewController?

    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func fillInfo(){
        
        Log.echo(key: "yud", text: "param is \(param)")
        
        if let duration = param["duration"] as? Int{
            
            self.slotDurationLbl?.text = "\(duration) mins"
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.thirtyMin{
            
            self.durationLbl?.text = "30 mins"
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.oneHour{
           
            self.durationLbl?.text = "1 hour"
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.twohour{
            
            self.durationLbl?.text = "2 hours"
        }
        if self.controller?.selectedDurationType == SessionTimeDateRootView.DurationLength.oneAndhour{
           
            self.durationLbl?.text = "1.3 hours"
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
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: newdate)
            }
            return ""
        }
        return ""
    }
    
    @IBAction func scheduleAction(sender:UIButton?){
        
        Log.echo(key: "yud", text: "The parameteres that I am sending is \(param)")
        scheduleAction()
    }
    
    func resetErrorlabel(){
        
        self.errorLabel?.text = ""
    }
    
    func showError(message:String = ""){
     
        self.errorLabel?.text = message
    }
    
    func scheduleAction(){
        
        self.controller?.showLoader()
        resetErrorlabel()
      
        ScheduleSessionRequest().save(params: param) { (success, message, response) in
         
            self.controller?.stopLoader()
            
            if !success{
                self.showError(message:message)
                return
            }
            
            guard let controller = SessionDoneController.instance() else{
                return
            }
            
            self.controller?.navigationController?.pushViewController(controller, animated:true)
        }
    }
}
