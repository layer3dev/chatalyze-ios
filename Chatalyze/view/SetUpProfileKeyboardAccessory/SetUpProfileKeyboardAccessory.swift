//
//  SetUpProfileKeyboardAccessory.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

protocol SetUpProfileKeyboardAccessoryDelegate {
    func doneTapped()
}

import UIKit
class SetUpProfileKeyboardAccessory: XibTemplate {
    
    @IBOutlet var numberOfText:UILabel?
    var delegate:SetUpProfileKeyboardAccessoryDelegate?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        
    }
    
    
    @IBAction func doneAction(sender:UIButton){
        delegate?.doneTapped()
    }
    
}
