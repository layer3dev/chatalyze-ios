//
//  AutographSignatureReponseBottomView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 21/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographSignatureReponseBottomView: ExtendedView {
    
    @IBOutlet var colorView:UIView?
    var delegate:AutographSignatureBottomResponseInterface?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
        
        colorView?.layer.borderWidth = UIDevice.current.userInterfaceIdiom == .pad ? 2.0:1.0
        colorView?.layer.borderColor = UIColor(red:224.0/255.0 , green: 224.0/255.0, blue: 224.0/255.0, alpha: 1).cgColor
        colorView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 25.0:20.0
        colorView?.backgroundColor = UIColor.black
        colorView?.layer.masksToBounds = true
    }
    
    @IBAction func undoAction(sender:UIButton?){
        self.delegate?.undoAction(sender: sender)
    }
    
    @IBAction func doneAction(sender:UIButton?){
        self.delegate?.doneAction(sender:sender)
    }
    
    @IBAction func colorAction(sender:UIButton?){
        self.delegate?.colorAction(sender:sender)
    }
}
