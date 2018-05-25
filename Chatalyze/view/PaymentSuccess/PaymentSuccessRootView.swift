//
//  PaymentSuccessRootView.swift
//  Chatalyze
//
//  Created by Mansa on 25/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import CountryPicker
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
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeCountryPicker()
        implementTapGestuePicker()
        paintInterface()
        initializeVariable()
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
        
        let locale = Locale(identifier: "en_US_POSIX")
        picker?.countryPickerDelegate = self
        picker?.showPhoneNumbers = true
        if let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            picker?.setCountry(code)
        }
    }
    
    func implementTapGestuePicker(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.countryAction(sender:)))
        tap.delegate = self
        pickerContainer?.addGestureRecognizer(tap)
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
        
        let startDate = DateParser.getDateTimeInUTCFromWeb(dateInString: "2018-05-25 09:23:42 +0000", dateFormat: "yyyy-MM-dd hh:mm:ss Z") ?? Date()
        let endDate = DateParser.getDateTimeInUTCFromWeb(dateInString: "2018-05-25 09:50:42 +0000", dateFormat: "yyyy-MM-dd hh:mm:ss Z") ?? Date()
        addEventToCalendar(title: "Girlfriend birthday", description: "Remember or die!", startDate: startDate, endDate: endDate) { (success, error) in
            
            if success{
                
                let alert = UIAlertController(title: "Chatalyze", message: "Event successfully added to calendar", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
                }))
                self.controller?.present(alert, animated: true, completion: {
                })
                return
            }
            self.noPermission()
            return
        }
    }
    
    @IBAction func addToCalendarAction(sender:UIButton){
      
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
    
   
    func noPermission()
    {
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide the permission to access the calender.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert) in
            if let settingUrl = URL(string:UIApplicationOpenSettingsURLString){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl)
                } else {
                    // Fallback on earlier versions
                }
            }
        }))
        self.controller?.present(alert, animated: true, completion: {
        })
    }
}


extension PaymentSuccessRootView:CountryPickerDelegate{
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        countryCodeField?.textField?.text = phoneCode
        countryCodeField?.image?.image = flag
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
        
        errorLabel?.text = ""
        if validateFields(){
            //save()
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
