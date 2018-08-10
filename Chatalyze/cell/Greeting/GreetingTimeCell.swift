
//
//  GreetingTimeCell.swift
//  Chatalyze
//
//  Created by Mansa on 07/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingTimeCell: ExtendedTableCell {

    @IBOutlet var timePicker:UIDatePicker?
    @IBOutlet var timeLable:UILabel?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        self.selectionStyle = .none
        self.timeLable?.text = selectedTime
    }
    
    @IBAction func timePickerAction(_ sender: Any) {

        self.timeLable?.text = selectedTime
    }
    
    var selectedTime:String{
        
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
