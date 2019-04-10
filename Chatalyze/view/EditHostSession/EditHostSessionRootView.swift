//
//  EditHostSessionRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import SDWebImage

class EditHostSessionRootView:EditScheduledSessionRootView {
    
    var info:EventInfo?
    var rootController:EditHostSessionController?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func setImage(info:EventInfo){
        
        let bannerUrl = info.eventBannerUrl ?? ""
        let requiredStr = bannerUrl.replacingOccurrences(of: "\\", with: "")
        Log.echo(key: "updates info banner url is", text: "\(requiredStr)")
        
        if let url = URL(string: requiredStr){
            
            self.controller?.showLoader()
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.highPriority, progress: { (m, n, g) in
            }) { (image, data, error, chache, status, url) in
                
                self.controller?.stopLoader()
                if error == nil{
                    
                    DispatchQueue.main.async {
                        
                        self.uploadedImage?.image = image
                        self.selectedImage = image
                        self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
                        self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
                        return
                    }
                }
                self.checkForProfileImage()
                return
            }
        }else{
            
            self.checkForProfileImage()
            return
        }
    }
    
    func checkForProfileImage(){
        
        self.imageUploadingView?.isUserInteractionEnabled = false
        if let userProfilePic = SignedUserInfo.sharedInstance?.profileImage{
            if let url = URL(string: userProfilePic){
                self.controller?.showLoader()
                self.uploadedImage?.sd_setImage(with: url, completed: { (image, error, cache, url) in
                    self.controller?.stopLoader()
                    if error == nil{
                        
                        self.uploadedImage?.contentMode = .scaleAspectFit
                        self.uploadedImage?.image = image
                        self.selectedImage = image
                        self.delegate?.selectedImage(image:self.selectedImage)
                        self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
                        self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
                        self.imageUploadingView?.isUserInteractionEnabled = true
                    }else{
                        self.imageUploadingView?.isUserInteractionEnabled = true
                    }
                })
            }else{
                self.imageUploadingView?.isUserInteractionEnabled = true
            }
        }else{
            self.imageUploadingView?.isUserInteractionEnabled = true
        }
    }
    
    
    func fillInfo(eventInfo:EventInfo?){
        
        guard let info = eventInfo else{
            return
        }
        
        self.info = info
        
        if let userInfo = SignedUserInfo.sharedInstance{
            
            let username = userInfo.fullName
            hostnameLbl?.text = username
        }
        if let title = info.title{
            
            sessionNameField?.textField?.text = title
            
            let firstStr = NSMutableAttributedString(string: title, attributes: self.titleAttribute as [NSAttributedString.Key : Any])
            
            let secondStr = NSMutableAttributedString(string: " Edit", attributes: editChatattributes as [NSAttributedString.Key : Any])
            
            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)
            
            //Log.echo(key: "yud", text: "price is requiered String \(requiredStr)")
            eventNameLbl?.attributedText = requiredStr
        }
        
        if let price = info.price{
            
            Log.echo(key: "yud", text: "Price is concentrated\(price)")
            
            costofEventLbl?.isHidden = false
            showNamePriceInfoView()
            
            var newFirstStr = "Book a \(Int(info.duration ?? 0.0))-minute chat ($\(String(format: "%.2f", Double(price))))"
            if price == 0 {
                newFirstStr = "Book a \(info.duration ?? 0)-minute chat"
            }
            
            let newAttrStr = newFirstStr.toAttributedString(font: "Nunito-ExtraBold", size: 15, color: UIColor.black, isUnderLine: false)
            
            costofEventLbl?.attributedText = newAttrStr
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EEEE, MMMM dd, yyyy"){
            
            self.dateTimeLbl?.text = startTime
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm"){
            
            self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "") \(startTime)-"
            
            if let endTime = DateParser.convertDateToDesiredFormat(date: info.end, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm a"){
                
                eventInfoLbl?.text = "\(Int(info.duration ?? 0.0))-minutes"
            }
        }
        
        fillTotalChats(info: info)
        let durate = Int(info.duration ?? 0.0)
        let numberofEvent = (self.totalTimeDuration/(durate))
        
        if info.eventDescription == "" {
            
            let txtStr = "I’m hosting \(numberofEvent) private one-on-one video chats during this session. Want to meet with me for \(durate) minutes to ask specific questions or get my advice about something? Click the “purchase a chat” button to reserve your time slot. Looking forward to speaking with you!"
            
            let attributedString = NSMutableAttributedString(string: txtStr)
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            //label.attributedText = attributedString
            
            eventDetailInfo?.attributedText = attributedString
            descriptionTextView?.attributedText = attributedString
            
        }else {
            
            let requiredstrOne = info.eventDescription?.replacingOccurrences(of: "<p>", with: "")
            
            let requiredDescription = requiredstrOne?.replacingOccurrences(of: "</p>", with: "\n")
            
            let attributedString = NSMutableAttributedString(string: requiredDescription ?? "")
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            eventDetailInfo?.attributedText = attributedString
            descriptionTextView?.attributedText = attributedString
            
        }
        
        if let screenShot = info.isScreenShotAllowed{
            
            if screenShot == "automatic"{
                
                selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 250.0)
            }else{
                selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 999.0)
            }
        }else{
            
            selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 999.0)
        }
        
        nextSlotTime?.text  = "\(getnextSlotInitialTime(info:info))-\(getNextSlotTime(info:info)) \(TimeZone.current.abbreviation() ?? "")"
        
        setImage(info:info)
    }
    
    
    func fillTotalChats(info:EventInfo){
        
        let durate = Int(info.duration ?? 0.0)
        if let startDate = info.startDate{
            if let endDate = info.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                let minutes = (timeDiffrence/60.0)
                Log.echo(key: "yud", text: "The total time of the event is \(timeDiffrence)")
                if minutes <= 0.0{
                    return
                }
                if minutes == 60{
                    
                    self.totalTimeDuration = 60
                    //totalSlots = 60/durate
                }
                if  minutes == 120{
                    
                    self.totalTimeDuration = 120
                    //totalSlots = 120/durate
                }
                if minutes == 30{
                    
                    self.totalTimeDuration = 30
                    //totalSlots = 30/durate
                }
                if minutes == 90{
                    
                    self.totalTimeDuration = 90
                    //totalSlots = 90/durate
                }
            }
        }
    }
    
    override func fillInfo(info: [String : Any]?, totalDurationofEvent: Int, selectedImage: UIImage?) {
        
        return
    }
    
    func getnextSlotInitialTime(info:EventInfo)->String{
        
        if let date = info.start as? String{
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let newdate = dateFormatter.date(from: date) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "hh:mm"
                return dateFormatter.string(from: newdate)
            }
            return ""
        }
        return ""
    }
    
    func getNextSlotTime(info:EventInfo)->String{
        
        if let date = info.start as? String {
            
            let durate = Int(info.duration ?? 0.0)
            let requiredDate = nextSessionTime(startDate:date,durate:durate)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            if let newdate = dateFormatter.date(from: requiredDate) {
                
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "hh:mm a"
                return dateFormatter.string(from: newdate)
            }
            return ""
        }
        return ""
    }
    
    override func saveEditedDescription(){
        
        //Verifying for title text to be empty.
        guard let descriptionText =  descriptionTextView?.text else {
            return
        }
        let description = descriptionText.replacingOccurrences(of: " ", with: "")
        if description == ""{
            return
        }
        
        self.info?.eventDescription = descriptionTextView?.text
        
        //self.editedParam["description"] = descriptionTextView?.text
        //self.fillInfo(info: self.param, totalDurationofEvent: self.totalTimeDuration, selectedImage: self.selectedImage)
        
        eventDetailInfo?.text = descriptionTextView?.text
        hideEditDescriptionInfoView()
        showDescriptionInfoView()
        self.rootController?.saveDescription()
    }
    
    
    override func updateEventBannerImage(){
        
        self.rootController?.updateSessionBannerImage()
    }
}
