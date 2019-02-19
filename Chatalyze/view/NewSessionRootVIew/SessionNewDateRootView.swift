//
//  SessionNewDateRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 29/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionNewDateRootViewDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class SessionNewDateRootView: ExtendedView {

    private let datePickerContainer = DatePicker()
    fileprivate var isDatePickerIsShowing = false
    @IBOutlet private var dateFld:SigninFieldView?
    var delegate:SessionNewDateRootViewDelegate?
    @IBOutlet private var chatPupView:ButtonContainerCorners?
    @IBOutlet private var nextView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeDatePicker()
        paintLayers()
    }
    
    func paintLayers(){        
        
        self.nextView?.layer.masksToBounds = true
        self.nextView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.nextView?.layer.borderWidth = 1
        self.nextView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        self.chatPupView?.layer.masksToBounds = true
        self.chatPupView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.chatPupView?.layer.borderWidth = 1
        self.chatPupView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        self.dateFld?.textFieldContainer?.layer.masksToBounds = true
        self.dateFld?.textFieldContainer?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.dateFld?.textFieldContainer?.layer.borderWidth = 1
        self.dateFld?.textFieldContainer?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
    }
    
    
    //MARK:- updating parameter
    private func updatingParameters(){
        
        guard let date = dateFld?.textField?.text else{
            return
        }
        delegate?.getSchduleSessionInfo()?.startDate = date
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
    
    @IBAction func nextAction(sender:UIButton){
        
        if !validateFields(){
            return
        }
        updatingParameters()
        DispatchQueue.main.async {
            self.delegate?.goToNextScreen()
        }
        Log.echo(key: "yud", text: "way is clear")        
    }
}

extension SessionNewDateRootView{
   
    //MARK:- Validations
    func validateFields()->Bool{
        
        let dateValidated  = validateDate()
        return dateValidated
    }
    
    func validateDate()->Bool{
        
        if(dateFld?.textField?.text == ""){
            
            dateFld?.showError(text: "Date is required.")
            return false
        }
        dateFld?.resetErrorStatus()
        return true
    }

}

extension SessionNewDateRootView:XibDatePickerDelegate{
    
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
        dateFld?.textField?.text = dateInStr
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
        dateFld?.textField?.text = dateInStr
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

