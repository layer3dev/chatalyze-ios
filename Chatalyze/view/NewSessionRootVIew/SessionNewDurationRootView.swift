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

class SessionNewDurationRootView:SessionTimeDateRootView {
    
    @IBOutlet var dateField:SigninFieldView?
    @IBOutlet var startTimeField:SigninFieldView?
    @IBOutlet var thirtyMinsBtn:UIButton?
    @IBOutlet var oneHourBtn:UIButton?
    @IBOutlet var oneAndHalfBtn:UIButton?
    @IBOutlet var twoHourBtn:UIButton?
    @IBOutlet var errorLbl:UILabel?
    var selectedDurationType:DurationLength = .none
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //paintFullBorder()
    }
    
    
//    func getEndDateForParameter()->String {
//
//        let startDate = getStartDateForParameter()
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        if let newDate = dateFormatter.date(from: startDate){
//
//            let calendar = Calendar.current
//            var date:Date?
//            if selectedDurationType == .thirtyMin{
//
//                date = calendar.date(byAdding: .minute, value: 30, to: newDate)
//            }else if selectedDurationType == .oneHour{
//
//                date = calendar.date(byAdding: .minute, value: 60, to: newDate)
//            }else if selectedDurationType == .oneAndhour{
//
//                date = calendar.date(byAdding: .minute, value: 90, to: newDate)
//
//            }else if selectedDurationType == .twohour{
//
//                date = calendar.date(byAdding: .minute, value: 120, to: newDate)
//            }else if selectedDurationType == .none{
//
//                return ""
//            }
//            if let date = date{
//                return dateFormatter.string(from: date)
//            }
//            return ""
//        }
//        return ""
//    }
    
//    func paintFullBorder(){
//
//        dateField?.isCompleteBorderAllow = true
//        startTimeField?.isCompleteBorderAllow = true
//    }
    
    
//    func resetDurationSelection(){
//
//        oneHourBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
//        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
//        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
//        twoHourBtn?.backgroundColor = UIColor(hexString: "#F1F4F5")
//    }
    
    //MARK:- Buttons Action
    
//    @IBAction func thirtyMinAction(sender:UIButton){
//
//        resetDurationSelection()
//        selectedDurationType = .thirtyMin
//        thirtyMinsBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
//        validateDuration()
//    }
//    @IBAction func oneHourAction(sender:UIButton){
//
//        resetDurationSelection()
//        selectedDurationType = .oneHour
//        oneHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
//        validateDuration()
//    }
//    @IBAction func oneAndHalfHourAction(sender:UIButton){
//
//        resetDurationSelection()
//        selectedDurationType = .oneAndhour
//        oneAndHalfBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
//        validateDuration()
//    }
//    @IBAction func twoHourAction(sender:UIButton){
//
//        resetDurationSelection()
//        selectedDurationType = .twohour
//        twoHourBtn?.backgroundColor = UIColor(hexString: "#E1E4E6")
//        validateDuration()
//    }
}
