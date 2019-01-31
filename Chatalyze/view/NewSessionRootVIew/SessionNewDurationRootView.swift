//
//  SessionNewDurationRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionNewDurationRootViewDelegate {
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class SessionNewDurationRootView:ExtendedView {
    
    enum DurationLength:Int{
        
        case thirtyMin = 0
        case oneHour = 1
        case oneAndhour = 2
        case twohour = 3
        case none = 4
    }
    
    @IBOutlet var dateField:SigninFieldView?
    @IBOutlet var startTimeField:SigninFieldView?
    @IBOutlet var thirtyMinsBtn:UIButton?
    @IBOutlet var oneHourBtn:UIButton?
    @IBOutlet var oneAndHalfBtn:UIButton?
    @IBOutlet var twoHourBtn:UIButton?
    @IBOutlet var errorLbl:UILabel?
    var selectedDurationType:DurationLength = .none
    var delegate:SessionNewDurationRootViewDelegate?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintFullBorder()
    }
    
    func fillData(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        startTimeField?.textField?.text = info.startTime
        dateField?.textField?.text = info.startDate
    }
    
    func paintFullBorder(){
        
        dateField?.isCompleteBorderAllow = true
        startTimeField?.isCompleteBorderAllow = true
    }
    
    func updateParameters(){

//        let startDate = getStartDateForParameter()
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        
        if let newDate = info.startDateTime{

            let calendar = Calendar.current
            var date:Date?
            if selectedDurationType == .thirtyMin{

                date = calendar.date(byAdding: .minute, value: 30, to: newDate)
                info.endDateTime = date
                return
            }else if selectedDurationType == .oneHour{

                date = calendar.date(byAdding: .minute, value: 60, to: newDate)
                info.endDateTime = date
                return
            }else if selectedDurationType == .oneAndhour{

                date = calendar.date(byAdding: .minute, value: 90, to: newDate)
                info.endDateTime = date
                return
            }else if selectedDurationType == .twohour{

                date = calendar.date(byAdding: .minute, value: 120, to: newDate)
                info.endDateTime = date
                return
            }else if selectedDurationType == .none{
                return
            }
        }
        return
    }
    
    func resetDurationSelection(){

        oneHourBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        twoHourBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
    }
    
    //MARK:- Buttons Action
    
    @IBAction func thirtyMinAction(sender:UIButton){

        resetDurationSelection()
        selectedDurationType = .thirtyMin
        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        let _ = validateDuration()
    }
    @IBAction func oneHourAction(sender:UIButton){

        resetDurationSelection()
        selectedDurationType = .oneHour
        oneHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        let _ = validateDuration()
    }
    @IBAction func oneAndHalfHourAction(sender:UIButton){

        resetDurationSelection()
        selectedDurationType = .oneAndhour
        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        let _ = validateDuration()
    }
    @IBAction func twoHourAction(sender:UIButton){

        resetDurationSelection()
        selectedDurationType = .twohour
        twoHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
        let _ = validateDuration()
    }
    
    
    @IBAction func nextAction(sender:UIButton){
        
        if !validateFields(){
          return
        }        
        updateParameters()
        delegate?.goToNextScreen()
        //Log.echo(key: "yud", text: "End date after updation is  \(delegate?.getSchduleSessionInfo()?.endDateTime)")
        
    }
    
    
    //MARK:- Validation
    
    func validateFields()->Bool{
        
        let isValidDuration = validateDuration()
        return isValidDuration
    }
    
    fileprivate func validateDuration()->Bool{

        if(selectedDurationType == .none){

            showError(message: "Session duration is required.")
            return false
        }
        resetErrorStatus()
        return true
    }

    func showError(message:String?){

        errorLbl?.text =  message ?? ""
    }
    
    func resetErrorStatus(){
        
        errorLbl?.text =  ""
    }
    
}
