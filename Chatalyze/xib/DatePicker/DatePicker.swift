//
//  DatePicker.swift
//  iOSConcept
//
//  Created by Yudhisther on 20/10/18.
//  Copyright © 2018 Yudhisther. All rights reserved.
//

import UIKit

protocol XibDatePickerDelegate {
    
    func doneTapped(selectedDate:Date?)
    func pickerAction(selectedDate:Date?)
}

class DatePicker:XibTemplate{
    
    @IBOutlet var timePicker:UIDatePicker?
    var delegate:XibDatePickerDelegate?
    
    override func viewDidLayout(){
        super.viewDidLayout()
       
        
    }
    
    
    @IBAction private func timePickerAction(_ sender: Any) {
        
        self.delegate?.pickerAction(selectedDate:timePicker?.date)
    }
    
    @IBAction private func doneAction(){
        self.delegate?.doneTapped(selectedDate:timePicker?.date)
    }
    
    private var selectedTime:String{
        
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "h:mm:ss a"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
}
