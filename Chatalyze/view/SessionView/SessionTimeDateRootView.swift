//
//  SessionTimeDateRootView.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionTimeDateRootView:ExtendedView{
    
    var isPickerHidden = true
    @IBOutlet var pickerContainer:UIView?
    @IBOutlet var timePicker:UIDatePicker?
    
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    @IBAction func pickerDoneAction(sender:UIButton?){
        
        if isPickerHidden == false {
            
            isPickerHidden = true
            pickerContainer?.isHidden = true
        }
    }
    
    @IBAction func datePickerAction(_ sender: Any){
        
     //   dateMonthMask?.put(text: selectedTime, into: (dateMonthField?.textField) ?? UITextField())
    }
    
    @IBAction func dateAction(sender:UIButton?){
        
        Log.echo(key: "yud", text: "I am calling date Action")
        
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
}
