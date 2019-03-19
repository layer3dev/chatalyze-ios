//
//  EditSessionFormRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditSessionFormRootView:ExtendedView{
    
    @IBOutlet var titleField:SigninFieldView?
    @IBOutlet var dateField:SigninFieldView?
    @IBOutlet var timeField:SigninFieldView?
    @IBOutlet var sessionLength:SigninFieldView?
    @IBOutlet var chatLength:SigninFieldView?
    @IBOutlet var freeField:SigninFieldView?
    @IBOutlet var priceField:SigninFieldView?
    @IBOutlet var editSessionButton:UIButton?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottonOffset:NSLayoutConstraint?
    private let datePickerContainer = DatePicker()
    fileprivate var isDatePickerIsShowing = false
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInteface()
    }
    
    func paintInteface() {
        
        self.titleField?.isCompleteBorderAllow = true
        self.dateField?.isCompleteBorderAllow = true
        self.timeField?.isCompleteBorderAllow = true
        self.sessionLength?.isCompleteBorderAllow = true
        self.chatLength?.isCompleteBorderAllow = true
        self.freeField?.isCompleteBorderAllow = true
        self.priceField?.isCompleteBorderAllow = true
        self.roundToEditSessionButton()
        self.initializeVariable()
    }
    
    func initializeVariable(){
        
        initializeDatePicker()
        scrollView?.bottomContentOffset = scrollContentBottonOffset
        self.titleField?.textField?.delegate = self
        self.dateField?.textField?.delegate = self
        self.timeField?.textField?.delegate = self
        self.sessionLength?.textField?.delegate = self
        self.chatLength?.textField?.delegate = self
        self.freeField?.textField?.delegate = self
        self.priceField?.textField?.delegate = self
        self.roundToEditSessionButton()
    }
    
    func roundToEditSessionButton() {
        
        editSessionButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 32.5 : 22.5
        editSessionButton?.layer.masksToBounds = true
    }
    
    //MARK:- Button Actions
    @IBAction func birthDayAction(sender:UIButton){
        
        if isDatePickerIsShowing{
            hidePicker()
            return
        }
        showDatePicker()
        return
    }
}

extension EditSessionFormRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = titleField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

extension EditSessionFormRootView{
    
    func resetErrorStatus(){
        
        titleField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
        
        let titleValidated  = titleValidation()
        let dateValidated  = validateDate()
        return titleValidated && dateValidated
    }
    
    fileprivate func titleValidation()->Bool{
        
        if(titleField?.textField?.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""){
            
            titleField?.showError(text: "Title is required.")
            return false
        }
        titleField?.resetErrorStatus()
        return true
    }
    
    func showError(message:String?){
        //errorLbl?.text =  message ?? ""
    }
}



extension EditSessionFormRootView{
    
    func validateDate()->Bool{
        
        if(dateField?.textField?.text == ""){
            
            dateField?.showError(text: "Date is required.")
            return false
        }
        dateField?.resetErrorStatus()
        return true
    }
}

extension EditSessionFormRootView:XibDatePickerDelegate{
    
    //MARK:- PICKER INITILIZATION
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
        guard let pickerDate = selectedDate else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: pickerDate)
        dateField?.textField?.text = dateInStr
        //birthDay = selectedDate
    }
    
    func pickerAction(selectedDate:Date?){
        
        guard let pickerDate = selectedDate else{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateInStr = dateFormatter.string(from: pickerDate)
        dateField?.textField?.text = dateInStr
        //birthDay = selectedDate
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
    
    //TODO:- Yet to implement BirthadyFieldScrolling
    func handleBirthadyFieldScrolling(){
    }
}

