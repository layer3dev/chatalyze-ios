//
//  EventPaymentRootView.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import InputMask

class EventPaymentRootView:ExtendedView,MaskedTextFieldDelegateListener{
    
    @IBOutlet var cardField:SigninFieldView?
    @IBOutlet var cvcField:SigninFieldView?
    @IBOutlet var dateMonthField:SigninFieldView?
    var controller:EventPaymentController?
    var maskedDelegate: MaskedTextFieldDelegate?
    var dateMonthMask: MaskedTextFieldDelegate?
    var cvcMask: MaskedTextFieldDelegate?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollViewBottomConstraints:NSLayoutConstraint?
    var isPickerHidden = true
    @IBOutlet var  pickerContainer:UIView?
    
    @IBOutlet var timePicker:UIDatePicker?
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintInterface()
        initializeVariable()
    }
    
    @IBAction func datePickerAction(_ sender: Any) {
     
        dateMonthMask?.put(text: selectedTime, into: (dateMonthField?.textField)!)
        print(selectedTime)
    }
    
    @IBAction func dateAction(){
        
        if isPickerHidden == true {
            
            isPickerHidden = false
            pickerContainer?.isHidden = false
        }else{
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    
    var selectedTime:String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "MM:yy"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd).replacingOccurrences(of: ":", with: "")
            }
            return ""
        }
    }
    
 
    
    
    func paintInterface(){
    }
    
    func initializeVariable(){
        
        scrollView?.bottomContentOffset = scrollViewBottomConstraints
        
         maskedDelegate = MaskedTextFieldDelegate(format: "[0000]-[0000]-[0000]-[0000]")
        maskedDelegate?.listener = self
        cardField?.textField?.delegate = maskedDelegate
        
        dateMonthMask = MaskedTextFieldDelegate(format: "[00]/[00]")
        dateMonthMask?.listener = self
        dateMonthField?.textField?.delegate = dateMonthMask
        
        cvcMask = MaskedTextFieldDelegate(format: "[000]")
        cvcMask?.listener = self
        cvcField?.textField?.delegate = cvcMask
        
        //cardMask.put(text: "", into: (cardField?.textField)!)
    }
    
    open func textField(_ textField: UITextField,didFillMandatoryCharacters complete:Bool,didExtractValue value: String){
      
        scrollView?.activeField = self
        print(value)
    }
}

extension EventPaymentRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = self
        return true
    }
}
