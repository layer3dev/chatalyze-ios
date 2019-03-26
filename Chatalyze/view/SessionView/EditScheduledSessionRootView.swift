//
//  EditScheduledSessionRootView.swift
//  Chatalyze
//
//  Created by Yudhisther on 30/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import QuartzCore
import CoreText
import UIKit
import SDWebImage

class EditScheduledSessionRootView:ExtendedView{
    
    var isProfileImageChecked = false
    
    let imagePicker = UIImagePickerController()
    let cropper = ImageCropper()
    
    var controller:EditScheduledSessionController?
    
    @IBOutlet var selfieViewHeightConstraints:NSLayoutConstraint?
    
    @IBOutlet var namePriceViewHieghtConstraints:NSLayoutConstraint?
    
    @IBOutlet var namePriceViewBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var namePriceEditViewHieghtConstraints:NSLayoutConstraint?
    @IBOutlet var namePriceEditViewBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var descriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var descriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var editDescriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var editDescriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var sessionNameLbl:UILabel?
   
    @IBOutlet var nextSlotTime:UILabel?
    
    var priceAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: 15)]
   
    var titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:UIFont(name: "Nunito-ExtraBold", size: 22)]
    
    var numberOfUnitAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8C9DA1"),NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: 16)]
   
    var editChatattributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: AppThemeConfig.themeColor),NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: 16)]

    
    var param = [String:Any]()
    
//    var param:[String:Any] = ["isFree": false, "screenshotAllow": "automatic", "title": "Chat Session", "end": "2018-08-31T06:06:27.000+0000", "duration": 5, "price": "1000", "start": "2018-08-31T05:36:27.000+0000", "userId": "36"]
    
    @IBOutlet var hostnameLbl:UILabel?
    
    @IBOutlet var eventNameLbl:UILabel?
    
    @IBOutlet var costofEventLbl:UILabel?
    
    @IBOutlet var dateTimeLbl:UILabel?
    
    @IBOutlet var eventInfoLbl:UILabel?
    
    @IBOutlet var eventDetailInfo:UILabel?
    
    @IBOutlet var descriptionBackLbl:UILabel?
  
    @IBOutlet var descriptionEditLbl:UILabel?
    
    @IBOutlet var sessionNameField:SigninFieldView?
   
    @IBOutlet var descriptionEditTextViewContainer:UIView?
   
    @IBOutlet var descriptionTextView:UITextView?
    
    @IBOutlet var scrollView:FieldManagingScrollView?
    
    @IBOutlet var contentBottomOffsetConstraints:NSLayoutConstraint?
    
    var delegate:UpdateForEditScheduleSessionDelgete?
    var totalTimeDuration = 0
    var editedParam = [String:Any]()
    
    @IBOutlet var imageUploadingView:UIView?
   
    @IBOutlet var uploadedImage:UIImageView?
   
    @IBOutlet var heightOfUploadImageConstraint:NSLayoutConstraint?
    
    @IBOutlet var heightOfuploadedImageConstraint:NSLayoutConstraint?
    
    @IBOutlet var editImageLbl:UILabel?
    
    var selectedImage:UIImage?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        paintInerface()
        paintBackAndEditDescription()
    }
    
    func paintBackAndEditDescription(){
        
        
        let textStr = "Description "
        let textStrMutable = textStr.toMutableAttributedString(font: "Nunito-ExtraBold", size: 15, color: UIColor.black, isUnderLine: false)
        
        let textEditStr = "Edit"
        let textEditStrMutable = textEditStr.toAttributedString(font: "Nunito-Regular", size: 14, color: UIColor(hexString: "#FAA579"), isUnderLine: true)
        
        textStrMutable.append(textEditStrMutable)
        
        let textStrNew = "Description "
        let textStrNewMutable = textStrNew.toMutableAttributedString(font: "Nunito-ExtraBold", size: 15, color: UIColor.black, isUnderLine: false)
        
        let textBackStr = "Back"
        let textBackStrAttr = textBackStr.toAttributedString(font: "Nunito-Regular", size: 14, color: UIColor(hexString: "#FAA579"), isUnderLine: true)
        
        textStrNewMutable.append(textBackStrAttr)
        
        descriptionBackLbl?.attributedText = textStrNewMutable
        descriptionEditLbl?.attributedText = textStrMutable
    }
    
    
    func paintImageUploadBorder(){
        
        imagePicker.delegate = self
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor(hexString: AppThemeConfig.themeColor).cgColor
        yourViewBorder.lineDashPattern = [8, 4]
        yourViewBorder.frame = (imageUploadingView?.bounds) ?? CGRect.zero
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: (imageUploadingView?.bounds) ?? CGRect.zero).cgPath
        imageUploadingView?.layer.addSublayer(yourViewBorder)
    }
    
    
    func paintInerface(){
        
        //paintImageUploadBorder()
        paintEditChangeImagelbl()
        imagePicker.navigationBar.barTintColor = UIColor.black
        descriptionEditTextViewContainer?.layer.borderWidth = 0.5
        descriptionEditTextViewContainer?.layer.borderColor = UIColor.lightGray.cgColor
        //eventDetailInfo?.lin
    }
    
    func fillInfo(info:[String:Any]?,totalDurationofEvent:Int,selectedImage:UIImage?){
        
        //Log.echo(key: "yud", text: "The current time zone ios \(Locale.current.identifier)\(Locale.current.regionCode)")
        
        Log.echo(key: "yud", text: "The info is \(info) and the total Duration of the event is \(totalDurationofEvent)")
        
        guard let info = info else {
            return
        }
        
        
        self.param = info
        //self.totalTimeDuration = totalDurationofEvent
        self.selectedImage = selectedImage
        
        if selectedImage != nil{
            
            uploadedImage?.image = selectedImage
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
        }else{
            
            //Disable Interaction of Upload View and check for profile Image If it exists,then show and set the variable to set happening same as when uploading the image through image Picker that else enable View.
            
            if isProfileImageChecked{
                
            }else{
                isProfileImageChecked = true
                imageUploadingView?.isUserInteractionEnabled = false
                if let userProfilePic = SignedUserInfo.sharedInstance?.profileImage{
                    if let url = URL(string: userProfilePic){
                        uploadedImage?.sd_setImage(with: url, completed: { (image, error, cache, url) in
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
            

        }
        
        
        if let userInfo = SignedUserInfo.sharedInstance{
            
            let username = userInfo.fullName
            hostnameLbl?.text = username
        }
        if let title = info["title"] as? String{
            
            sessionNameField?.textField?.text = title
            
            let firstStr = NSMutableAttributedString(string: title, attributes: self.titleAttribute as [NSAttributedString.Key : Any])
            
            let secondStr = NSMutableAttributedString(string: " Edit", attributes: editChatattributes as [NSAttributedString.Key : Any])
            
            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)
            
            //Log.echo(key: "yud", text: "price is requiered String \(requiredStr)")
            eventNameLbl?.attributedText = requiredStr
        }
        
        if let price = info["price"]{
            
            //Book a 2-minute chat ($2121.00)
            
            //\(info["duration"] ?? 0.0)
            
            costofEventLbl?.isHidden = false
            
            var newFirstStr = "Book a \(info["duration"] ?? 0.0)-minute chat ($\(price))"
            
            let newAttrStr = newFirstStr.toAttributedString(font: "Nunito-ExtraBold", size: 15, color: UIColor.black, isUnderLine: false)
            
            costofEventLbl?.attributedText = newAttrStr
            
            
//            let firstStr = NSMutableAttributedString(string: "$ \(price)", attributes: self.priceAttribute as [NSAttributedString.Key : Any])
//
//            let secondStr = NSMutableAttributedString(string: " per chat", attributes: numberOfUnitAttributes as [NSAttributedString.Key : Any])
//
//            let requiredStr = NSMutableAttributedString()
//            requiredStr.append(firstStr)
//            requiredStr.append(secondStr)
//
//            Log.echo(key: "yud", text: "price is requiered String \(requiredStr) and the price is \(price)")
//
//            costofEventLbl?.attributedText = requiredStr
           
            //costofEventLbl?.text = "asdasfdsfds"
            
            Log.echo(key: "yud", text: "costofEventLbl text is \(costofEventLbl?.text)")
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EEEE, MMMM dd, yyyy"){
            
            self.dateTimeLbl?.text = startTime
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm"){
            
            self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "") \(startTime)-"
            
            if let endTime = DateParser.convertDateToDesiredFormat(date: info["end"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm a"){
                
               // self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "")\(endTime) \(Locale.current.regionCode ?? "")"
                
               // eventInfoLbl?.text = "\(info["duration"] ?? 0.0)-minutes video chats available from \(startTime)-\(endTime) \(Locale.current.regionCode ?? "")"
                
                eventInfoLbl?.text = "\(info["duration"] ?? 0.0)-minutes"
                
               // 3-minute video chats available from 07:00 - 07:30 PM IST
            }
        }
        
        fillTotalChats(info: info)
        let durate = info["duration"] as? Int
        let numberofEvent = (self.totalTimeDuration/(durate ?? 1))
        
        if param["description"] == nil{
            
//            I’m hosting 15 private one-on-one video chats during this session. Want to meet with me for 2 minutes to ask specific questions or get my advice about something? Click the “purchase a chat” button to reserve your time slot. Looking forward to speaking with you!
            
            //eventDetailInfo?.text = "I'm hosting \(numberofEvent) private one-on-one video chats during this session. If you purchase a chat, you'll receive a scheduled time when we'll connect. We'll talk, you can ask questions, and we'll get to know each other!"
            
            
            let txtStr = "I’m hosting \(numberofEvent) private one-on-one video chats during this session. Want to meet with me for \(durate ?? 0) minutes to ask specific questions or get my advice about something? Click the “purchase a chat” button to reserve your time slot. Looking forward to speaking with you!"
                        
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
            
            
//            eventDetailInfo?.text =  "I’m hosting \(numberofEvent) private one-on-one video chats during this session. Want to meet with me for \(durate ?? 0) minutes to ask specific questions or get my advice about something? Click the “purchase a chat” button to reserve your time slot. Looking forward to speaking with you!"
//
//
//            descriptionTextView?.text = "I’m hosting \(numberofEvent) private one-on-one video chats during this session. Want to meet with me for \(durate ?? 0) minutes to ask specific questions or get my advice about something? Click the “purchase a chat” button to reserve your time slot. Looking forward to speaking with you!"
        }else{
            
            
            let attributedString = NSMutableAttributedString(string: param["description"] as? String ?? "")
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            //label.attributedText = attributedString
            
           // eventDetailInfo?.attributedText = attributedString
            
            eventDetailInfo?.attributedText = attributedString
            descriptionTextView?.attributedText = attributedString
            
          
//            eventDetailInfo?.text = param["description"] as? String
//            descriptionTextView?.text = param["description"] as? String
        }
        
        if let screenShot = info["screenshotAllow"] as? String{
            
            if screenShot == "automatic"{
                
                selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 250.0)
            }else{
                selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 999.0)
            }
        }else{
            
            selfieViewHeightConstraints?.priority = UILayoutPriority(rawValue: 999.0)
        }
        
        
        nextSlotTime?.text  = "\(getnextSlotInitialTime())-\(getNextSlotTime()) \(TimeZone.current.abbreviation() ?? "")"
        
        
//        if let startTime = DateParser.convertDateToDesiredFormat(date: info["start"] as? String, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd"){

        //
//            self.eventDetailInfo?.text = "\(self.eventDetailInfo?.text ?? "") \(startTime)! Here's how:"
//        }
    }
    
    
    func getnextSlotInitialTime()->String{
        
        if let date = self.param["start"] as? String{
            
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
    
    func getNextSlotTime()->String{
        
        if let date = self.param["start"] as? String{
            if let durate = self.param["duration"] as? Int{
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
        return ""
    }
    
    
     func nextSessionTime(startDate:String,durate:Int)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let newDate = dateFormatter.date(from: startDate){
            
            
            let calendar = Calendar.current
            var date:Date?
            if durate == 2{
                
                date = calendar.date(byAdding: .minute, value: 2, to: newDate)
            }else if durate == 3{
                
                date = calendar.date(byAdding: .minute, value: 3, to: newDate)
            }else if durate == 5{
                
                date = calendar.date(byAdding: .minute, value: 5, to: newDate)
                
            }else if durate == 10{
                
                date = calendar.date(byAdding: .minute, value: 10, to: newDate)
            }else if durate == 15{
                
                date = calendar.date(byAdding: .minute, value: 15, to: newDate)
            }else if durate == 30{
                
                date = calendar.date(byAdding: .minute, value: 30, to: newDate)
            }
            if let date = date{
                
                return dateFormatter.string(from: date)
            }
            return ""
        }
        return ""
    }   

    
    func fillTotalChats(info:[String:Any]?){
        
        guard let currentParams = info else {
            return
        }
        
        var singleChatMinutes =  0
        var totalMinutesOfChat = 0
        var totalSlots = 0
        
        if let durate = currentParams["duration"] as? Int{
            singleChatMinutes = durate
            if let durationType =  currentParams["selectedHourSlot"] as? SessionTimeDateRootView.DurationLength {
                
                if durationType == .none{
                    return
                }
                if durationType == .oneHour{
                    
                    self.totalTimeDuration = 60
                    totalSlots = 60/durate
                }
                if durationType == .twohour{
                    
                    self.totalTimeDuration = 120
                    totalSlots = 120/durate
                }
                if durationType == .thirtyMin{
                    
                    self.totalTimeDuration = 30
                    totalSlots = 30/durate
                }
                if durationType == .oneAndhour{
                    
                    self.totalTimeDuration = 90
                    totalSlots = 90/durate
                }
            }
        }
    }
    
    func askToSelectUploadType(){
        
        let sheet = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            //            let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate"))
            //            self.addMedia(photoItem!)
            self.openGallery()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(photoAction)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.controller?.present(sheet, animated: true, completion: nil)
    }
    
    
    func openCamera(){
        
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            return
        }
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.controller?.present(imagePicker, animated: true, completion: nil)
            return;
            
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.controller?.present(self.imagePicker, animated: true, completion: nil)
                    return;
                    
                } else {
                    
                    let alert = UIAlertController(title: AppInfoConfig.appName, message: "Please give the camera permission from the settings", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                        
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        
//                        UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: ., completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                    }))
                    self.controller?.present(alert, animated: true, completion: {
                    })
                }
            })
        }
    }
    func openGallery(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.controller?.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(sender:UIButton?){
        
        
        cropper.show(controller: self.controller)
        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//
//        self.controller?.present(imagePicker, animated: true, completion: {
//
//        })
        //imagePicker.popoverPresentationController?. = sender
    }
    
    @objc func changeImage(sender:UIButton?){
       
        delegate?.selectedImage(image:nil)
        uploadedImage?.image = UIImage(named:"base")
        selectedImage = nil
        heightOfUploadImageConstraint?.priority = UILayoutPriority(250.0)
        heightOfuploadedImageConstraint?.priority = UILayoutPriority(999.0)
    }
    
    
    @IBAction func saveTitleAction(sender:UIButton?){
        
        //Verifying for title text to be empty.
        guard let titleText =  sessionNameField?.textField?.text else {
            return
        }
        let text = titleText.replacingOccurrences(of: " ", with: "")
        if text == ""{
            return
        }
        self.param["title"] = sessionNameField?.textField?.text
        self.editedParam["title"] = sessionNameField?.textField?.text
        self.fillInfo(info: self.param, totalDurationofEvent: self.totalTimeDuration, selectedImage: self.selectedImage)
        delegate?.updatedEditedParams(info:self.editedParam)
        hideNamePriceEditInfoView()
        showNamePriceInfoView()
    }
    
    @IBAction func saveDescriptionAction(sender:UIButton?){
        
        saveEditedDescription()
    }
    
    func saveEditedDescription(){
        
        //Verifying for title text to be empty.
        guard let descriptionText =  descriptionTextView?.text else {
            return
        }
        let description = descriptionText.replacingOccurrences(of: " ", with: "")
        if description == ""{
            return
        }
        
        self.param["description"] = descriptionTextView?.text
        self.editedParam["description"] = descriptionTextView?.text
        self.fillInfo(info: self.param, totalDurationofEvent: self.totalTimeDuration, selectedImage: self.selectedImage)
        delegate?.updatedEditedParams(info:self.editedParam)
        hideEditDescriptionInfoView()
        showDescriptionInfoView()
    }
    
    
    func initializeVariable(){
        
        implementGestureOnEditSessionName()
        scrollView?.bottomContentOffset = contentBottomOffsetConstraints
        sessionNameField?.textField?.delegate = self
        descriptionTextView?.delegate = self
        initializeCropper()
    }
    
    func updateEventBannerImage(){
        //Just to override
    }
    
    
    func initializeCropper(){
       
        cropper.isOnlySquare = true
        cropper.getCroppedImage = {(croppedImage) in
           
            self.uploadedImage?.contentMode = .scaleAspectFit
            self.uploadedImage?.image = croppedImage
            self.selectedImage = croppedImage
            self.updateEventBannerImage()
            self.delegate?.selectedImage(image:self.selectedImage)
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
        }
    }
    
    
    func paintEditChangeImagelbl(){
        
        var fontSize = 15
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 18
        }
        
        let text = "Change picture"
        editImageLbl?.attributedText = text.toAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#Faa579"), isUnderLine: true)
    }
    
    func implementGestureOnEditSessionName(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editSessionNameAction))
        self.sessionNameLbl?.isUserInteractionEnabled = true
        self.sessionNameLbl?.isEnabled = true
        sessionNameLbl?.addGestureRecognizer(tapGesture)
        
        let tapGestureOnEditDescription = UITapGestureRecognizer(target: self, action: #selector(self.editDescriptionAction))
        self.descriptionEditLbl?.isUserInteractionEnabled = true
        self.descriptionEditLbl?.isEnabled = true
        descriptionEditLbl?.addGestureRecognizer(tapGestureOnEditDescription)
        
        let tapGestureOnDisbleEditDescription = UITapGestureRecognizer(target: self, action: #selector(self.disableEditDescriptionAction))
        self.descriptionBackLbl?.isUserInteractionEnabled = true
        self.descriptionBackLbl?.isEnabled = true
        descriptionBackLbl?.addGestureRecognizer(tapGestureOnDisbleEditDescription)        
        
        let tapGestureEditImage = UITapGestureRecognizer(target: self, action: #selector(self.changeImage(sender:)))
        self.editImageLbl?.isUserInteractionEnabled = true
        self.editImageLbl?.isEnabled = true
        editImageLbl?.addGestureRecognizer(tapGestureEditImage)
    }
    
    func hideNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    @objc func editSessionNameAction(){
        
        showNamePriceEditInfoView()
        hideNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditSessionNameAction(){
        
        hideNamePriceEditInfoView()
        showNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func editDescriptionAction(){
        
        hideDescriptionInfoView()
        showEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditDescriptionAction(){
        
        showDescriptionInfoView()
        hideEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
}

extension EditScheduledSessionRootView:UITextFieldDelegate,UITextViewDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = sessionNameField
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        scrollView?.activeField = descriptionTextView
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.count + text.count > 3800{
            return false
        }
        return true
    }
}

extension EditScheduledSessionRootView:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let  chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            
            uploadedImage?.contentMode = .scaleAspectFit
            uploadedImage?.image = chosenImage
            selectedImage = chosenImage
            delegate?.selectedImage(image:selectedImage)
            self.heightOfUploadImageConstraint?.priority = UILayoutPriority(999.0)
            self.heightOfuploadedImageConstraint?.priority = UILayoutPriority(250.0)
            self.controller?.dismiss(animated:true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.controller?.dismiss(animated: true, completion: {
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
