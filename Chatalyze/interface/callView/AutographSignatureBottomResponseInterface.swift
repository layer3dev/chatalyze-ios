//
//  AutographSignatureBottomResponseInterface.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 21/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

protocol AutographSignatureBottomResponseInterface {
    
    func doneAction(sender:UIButton?)
    func undoAction(sender:UIButton?)
    func colorAction(sender:UIButton?)
    func pickerSelectedColor(color:UIColor?)
}
