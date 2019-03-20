//
//  TippingCardInfoRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 13/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import InputMask


class TippingCardInfoRootView: ExtendedView {
    
    @IBOutlet private var payNow:UIView?
    @IBOutlet private var profileImage:UIImageView?
    @IBOutlet var cardField:SigninFieldView?
    @IBOutlet var cvcField:SigninFieldView?
    @IBOutlet var dateMonthField:SigninFieldView?
    var maskedDelegate: MaskedTextFieldDelegate?
    var dateMonthMask: MaskedTextFieldDelegate?
    var cvcMask: MaskedTextFieldDelegate?
    var isDatePickerIsShowing = false
    let datePickerContainer = DatePicker()
    
    @IBOutlet var cardRoundView:UIView?
    @IBOutlet var cvcRoundView:UIView?
    @IBOutlet var dateRoundView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintView()
        initializeVariable()
        initializeDatePicker()
        paintTextfieldPlaceHolder()
    }
    
    func paintView(){
        
        profileImage?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 55:45
        profileImage?.layer.masksToBounds = true
        
        cardRoundView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        cardRoundView?.layer.masksToBounds = true
        
        cvcRoundView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        cvcRoundView?.layer.masksToBounds = true
        
        dateRoundView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dateRoundView?.layer.masksToBounds = true
        
        payNow?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        payNow?.layer.masksToBounds = true
    }
    
    func paintTextfieldPlaceHolder(){
        
        var fontSize:CGFloat = 16.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 24.0
        }
        
        cardField?.textField?.attributedPlaceholder =
            NSAttributedString(string: "Card number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: fontSize)])
        
        dateMonthField?.textField?.attributedPlaceholder =
            NSAttributedString(string: "Expiry: MM/YY", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: fontSize)])
        
        cvcField?.textField?.attributedPlaceholder =
            NSAttributedString(string: "CVC", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular", size: fontSize)])
    }
    
    func initialize(){
        
        datePickerContainer.delegate = self
        //dateTimePicker.
    }
    
    @IBAction func dateAction(sender:UIButton?){
        
        Log.echo(key: "yud", text: "I am calling date Action")
        
        if isDatePickerIsShowing == true {
            hidePicker()
        }else{
            showDatePicker()
        }
    }
    
    var selectedTime:String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "MM:yy"
            if let cd  = datePickerContainer.timePicker?.date{
                return dateFormatter.string(from: cd).replacingOccurrences(of: ":", with: "")
            }
            return ""
        }
    }
    
    
    func initializeVariable(){
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "[0000]-[0000]-[0000]-[0000]")
        
        maskedDelegate?.listener = self
        cardField?.textField?.delegate = maskedDelegate
        
        dateMonthMask = MaskedTextFieldDelegate(primaryFormat: "[00]/[00]")
        dateMonthMask?.listener = self
        dateMonthField?.textField?.delegate = dateMonthMask
        
        cvcMask = MaskedTextFieldDelegate(primaryFormat: "[000]")
        cvcMask?.listener = self
        cvcField?.textField?.delegate = cvcMask
    }
}

extension TippingCardInfoRootView:MaskedTextFieldDelegateListener{
}

extension TippingCardInfoRootView:XibDatePickerDelegate{
    
    //MARK:- PICKER INITIALIZATION
    
    func initializeDatePicker(){
        
        datePickerContainer.frame = self.frame
        datePickerContainer.timePicker?.datePickerMode = .date
        datePickerContainer.delegate = self
        datePickerContainer.timePicker?.minimumDate = Date()
        //TODO:- Implement the minimum date
        //datePicker.timePicker?.minimumDate
        datePickerContainer.isHidden = true
        self.addSubview(datePickerContainer)
    }
    
    func doneTapped(selectedDate:Date?){
        
        hidePicker()
        dateMonthMask?.put(text: selectedTime, into: (dateMonthField?.textField) ?? UITextField())
    }
    
    func pickerAction(selectedDate:Date?){
        
        dateMonthMask?.put(text: selectedTime, into: (dateMonthField?.textField) ?? UITextField())
    }
    
    private func showDatePicker(){
        
        handleBirthadyFieldScrolling()
        self.isDatePickerIsShowing = true
        self.datePickerContainer.isHidden = false
    }
    
    private func hidePicker(){
        
        handleBirthadyFieldScrolling()
        self.isDatePickerIsShowing = false
        self.datePickerContainer.isHidden = true
    }
    
    //    private func getBirthDayDateForParam()->String{
    //
    //        guard let date = birthDay else {
    //            return ""
    //        }
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "dd/MM/yyyy"
    //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    //        let dateInStr = dateFormatter.string(from: date)
    //        Log.echo(key: "yud", text: "Parameter dob is \(dateInStr)")
    //        return dateInStr
    //    }
    
    //TODO:- Yet to implement BirthadyFieldScrolling
    func handleBirthadyFieldScrolling(){
    }
}

