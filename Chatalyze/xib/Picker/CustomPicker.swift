//
//  CustomPicker.swift
//  Surobelly
//
//  Created by mansa infotech on 19/01/19.
//  Copyright © 2019 mansa infotech. All rights reserved.
//

import UIKit

protocol CustomPickerDelegate {
    func pickerDoneTapped(type:CustomPicker.pickerType)
}

class CustomPicker:XibTemplate{
        
    enum pickerType:Int{
        
        case chatLength = 0
        case sessionLength = 1
        case none = 2
    }
    
    @IBOutlet var picker:UIPickerView?
    var delegate:CustomPickerDelegate?
    var currentType = pickerType.none
    override func viewDidLayout(){
        super.viewDidLayout()
    }
    
    @IBAction func doneAction(){
        delegate?.pickerDoneTapped(type:currentType)
    }
    
}
