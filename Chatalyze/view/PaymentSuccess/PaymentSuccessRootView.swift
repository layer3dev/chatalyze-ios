//
//  PaymentSuccessRootView.swift
//  Chatalyze
//
//  Created by Mansa on 25/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import EventKit

class PaymentSuccessRootView: ExtendedView {
    
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    var isCountryPickerHidden = true
    var chatUpdates = false
    var controller:PaymentSuccessController?
    @IBOutlet var picker:CountryPicker?
    @IBOutlet var countryCodeField:SigninFieldView?
    @IBOutlet var mobileNumberField:SigninFieldView?
    @IBOutlet var errorLabel:UILabel?
    @IBOutlet var chatUpdatesImage:UIImageView?
    @IBOutlet var pickerContainer:UIView?
    @IBOutlet var addtocalendarView:UIView?
    let eventStore = EKEventStore()
    @IBOutlet var chatDetailLbl:UILabel?
    var info:PaymentSuccessInfo?
    @IBOutlet var saveLbl:UILabel?    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeCountryPicker()
        //implementTapGestuePicker()
        paintInterface()
        initializeVariable()
        initializeChatInfo()
        paintMobileField()
    }
    
    func paintMobileField(){
        
        guard let mobileReminderInfo = SignedUserInfo.sharedInstance?.eventMobReminder else{
            return
        }
        
        if mobileReminderInfo{
            
            self.controller?.heightOfMobileField?.constant = 0
            self.controller?.heightOfMobileAlertField?.constant = 150
            self.superview?.updateConstraints()
            self.scrollView?.layoutIfNeeded()
            //self.view.updateConstraints()
            self.superview?.layoutIfNeeded()
            return
        }
        self.controller?.heightOfMobileField?.constant = 280
        self.controller?.heightOfMobileAlertField?.constant = 0
        self.superview?.updateConstraints()
        self.scrollView?.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
    }
    
    func initializeChatInfo(){
        
        //create attributed string        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            let greenAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 24)]
            
            let grayAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#B7B7B7"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 24)]
            
            let firstStr = NSMutableAttributedString(string: "Thank you for your purchase! You have ", attributes: grayAttribute)
            
            let slotNumber = NSMutableAttributedString(string: "Chat \(self.info?.slotNumber ?? "") ", attributes: greenAttribute)
            
            let secondStr = NSMutableAttributedString(string: "during the session, scheduled from ", attributes: grayAttribute)
            
            let time = NSMutableAttributedString(string: "\(self.info?.startTime ?? "") - \(self.info?.endTime ?? "") ", attributes: greenAttribute)
            
            let fourthStr = NSMutableAttributedString(string: "on ", attributes: grayAttribute)
            
            let fifthStr = NSMutableAttributedString(string: "\(self.info?.startDate ?? "")", attributes: greenAttribute)
            
            let sixthStr = NSMutableAttributedString(string: ". Your ticket to joint the session is now in the Event Tickets Section of your account", attributes: grayAttribute)
            
            let requiredString:NSMutableAttributedString = NSMutableAttributedString()
            
            requiredString.append(firstStr)
            requiredString.append(slotNumber)
            requiredString.append(secondStr)
            requiredString.append(time)
            requiredString.append(fourthStr)
            requiredString.append(fifthStr)
            requiredString.append(sixthStr)
            
            chatDetailLbl?.attributedText = requiredString
            
        }else{
            
            let greenAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#27B879"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Bold", size: 18)]
            
            let grayAttribute = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#B7B7B7"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 18)]
            
            let firstStr = NSMutableAttributedString(string: "Thank you for your purchase! You have ", attributes: grayAttribute)
            
            let slotNumber = NSMutableAttributedString(string: "Chat \(self.info?.slotNumber ?? "") ", attributes: greenAttribute)
            
            let secondStr = NSMutableAttributedString(string: "during the session, scheduled from ", attributes: grayAttribute)
            
            let time = NSMutableAttributedString(string: "\(self.info?.startTime ?? "") - \(self.info?.endTime ?? "") ", attributes: greenAttribute)
            
            let fourthStr = NSMutableAttributedString(string: "on ", attributes: grayAttribute)
            
            let fifthStr = NSMutableAttributedString(string: "\(self.info?.startDate ?? "")", attributes: greenAttribute)
            
            let sixthStr = NSMutableAttributedString(string: ". Your ticket to joint the session is now in the Event Tickets Section of your account", attributes: grayAttribute)
            
            let requiredString:NSMutableAttributedString = NSMutableAttributedString()
            
            requiredString.append(firstStr)
            requiredString.append(slotNumber)
            requiredString.append(secondStr)
            requiredString.append(time)
            requiredString.append(fourthStr)
            requiredString.append(fifthStr)
            requiredString.append(sixthStr)
            chatDetailLbl?.attributedText = requiredString
        }
        //NSMutableAttribte String after appending do not produce the new string but only modilfy itself.
    }
    
    func paintInterface(){
        
        addtocalendarView?.layer.cornerRadius = 2
        addtocalendarView?.layer.masksToBounds = true
        addtocalendarView?.layer.borderWidth = 1
        addtocalendarView?.layer.borderColor = UIColor(hexString: "#999999").cgColor
    }
    
    func initializeVariable(){
        
        scrollView?.bottomContentOffset = scrollContentBottomOffset
        mobileNumberField?.textField?.delegate = self
    }
    
    func initializeCountryPicker(){
        
        picker?.delegate = self
    }
    
    func implementTapGestuePicker(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.countryAction(sender:)))
        tap.delegate = self
        pickerContainer?.addGestureRecognizer(tap)
    }
    
    @IBAction func skipAction(sender:UIButton?){
        
        DispatchQueue.main.async {
            self.controller?.dismiss(animated: false, completion: {
                RootControllerManager().getCurrentController()?.selectAccountTabWithTicketScreen()
            })
        }
    }
    
    @IBAction func countryAction(sender:UIButton){
        
        if isCountryPickerHidden{
            
            isCountryPickerHidden = false
            pickerContainer?.isHidden = false
        }else{
            
            isCountryPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func addEvent(){
        
        let startDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.info?._startDate, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        let endDate = DateParser.getDateTimeInUTCFromWeb(dateInString: self.info?._endDate, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") ?? Date()
        
        self.controller?.showLoader()
        
        addEventToCalendar(title: "Chatalyze Event", description: "\(chatDetailLbl?.text ?? "")", startDate: startDate, endDate: endDate) { (success, error) in
            
            self.controller?.stopLoader()
            if success{
                
                let alert = UIAlertController(title: "Chatalyze", message: "Event successfully added to calendar", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
                }))
                self.controller?.present(alert, animated: false, completion: {
                })
                return
            }
            self.noPermission()
            return
        }
    }
    
    @IBAction func addToCalendarAction(sender:UIButton){
        
        sender.isUserInteractionEnabled = false
        generateEvent()
    }
    func generateEvent() {
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status)
        {
        case EKAuthorizationStatus.notDetermined:
            addEvent()
            break
        case EKAuthorizationStatus.authorized:
            addEvent()
            break
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            noPermission()
            break
        }
    }
    
    
    func noPermission(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide the permission to access the calender.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
            
            if let settingUrl = URL(string:UIApplicationOpenSettingsURLString){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl)
                } else {
                    //Fallback on earlier versions
                }
            }
        }))
        self.controller?.present(alert, animated: false, completion: {
        })
    }
}


extension PaymentSuccessRootView:CountryPickerDelegate{
    
    func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
        
        //self.countryCodeField?.image =
        countryCodeField?.textField?.text = picker.selectedCountryCode
        countryCodeField?.image?.image = picker.selectedImage
        
        
        if let countryCode = (picker.selectedLocale as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
        }
        
        for info in IsoCountries.allCountries{
            if info.alpha2 == code{
                
                countryCodeField?.textField?.text = info.calling
            }
        }
    }
    
    
    @IBAction func chatTimeAction(sender:UIButton){
        
        if chatUpdates{
            chatUpdates = false
            chatUpdatesImage?.image = UIImage(named: "untick")
            return
        }
        chatUpdates = true
        chatUpdatesImage?.image = UIImage(named: "tick")
    }
    
    @IBAction func save(sender:UIButton){
        
        if let eventReminder = SignedUserInfo.sharedInstance?.eventMobReminder{
            
            if eventReminder == true {
                //Implement here for the navigation at the UItickets.
                self.skipAction(sender: nil)
                return
            }
        }
        errorLabel?.text = ""
        if validateFields(){
            saveMobileNumber()
        }
    }
    
    func saveMobileNumber(){
        
        guard let countryCode = countryCodeField?.textField?.text else{
            return
        }
        guard let mobileNumber  = mobileNumberField?.textField?.text else {
            return
        }
        let requiredcountryCode = countryCode.replacingOccurrences(of: "+", with: "")
        
        self.controller?.showLoader()
        
        //chatUpdates
        SaveMobileForEventReminder().save(mobilenumber: mobileNumber, countryCode: requiredcountryCode,saveForFuture : chatUpdates) { (success, message, response) in
            
            self.controller?.stopLoader()
            if !success{
                
                self.errorLabel?.text = message
                self.skipAction(sender: nil)
                return
            }
            if let instance = SignedUserInfo.sharedInstance{
                if self.chatUpdates{
                
                    instance.eventMobReminder = true
                    instance.save()
                }
            }
            self.errorLabel?.text = message
            self.skipAction(sender: nil)
        }
    }
}

extension PaymentSuccessRootView{
    
    func validateFields()->Bool{
        
        resetErrorStatus()
        let codeValidate = validateCountryCode()
        let mobileValidate = validateMobileNumber()
        return codeValidate && mobileValidate
    }
    
    func resetErrorStatus(){
        
        errorLabel?.text = ""
        mobileNumberField?.resetErrorStatus()
        countryCodeField?.resetErrorStatus()
    }
    
    func showError(text : String?){
        
        errorLabel?.text = text
    }
    
    fileprivate func validateCountryCode()->Bool{
        
        if(countryCodeField?.textField?.text == ""){
            
            countryCodeField?.showError(text: "CountryCode field can't be left empty !")
            return false
        }
        countryCodeField?.resetErrorStatus()
        return true
    }
    
    fileprivate func validateMobileNumber()->Bool{
        
        if(mobileNumberField?.textField?.text == ""){
            
            mobileNumberField?.showError(text: "Mobile number field can't be left empty !")
            return false
        }else if (mobileNumberField?.textField?.text?.count ?? 0) < 10{
            
            mobileNumberField?.showError(text: "Mobile number looks incorrect !")
            return false
        }
        mobileNumberField?.resetErrorStatus()
        return true
    }
}


extension PaymentSuccessRootView:UIGestureRecognizerDelegate{
}

extension UIAlertController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
}

extension PaymentSuccessRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView?.activeField = textField
        return true
    }
}
