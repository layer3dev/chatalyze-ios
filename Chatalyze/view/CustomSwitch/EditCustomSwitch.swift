//
//  EditCustomSwitch.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EditCustomSwitch: ExtendedView {
    
    @IBOutlet var leadingCircleConstraint:NSLayoutConstraint?
    @IBOutlet var circleView:UIView?
    var isStatusActive = false
    var isOn:Bool{
        return isStatusActive
    }
    
    var toggleAction:(()->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
        
        self.layer.cornerRadius = 17.5
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(red: 250.0/255.0, green: 165.0/255.0, blue: 122.0/255.0, alpha: 1).cgColor
        self.layer.masksToBounds = true
        circleView?.layer.cornerRadius = 11
        circleView?.layer.masksToBounds = true
        setOn()
    }
    
    
    @IBAction func toogleAction(){
        
        if isStatusActive {
            setOff()
            toggleAction?()
            return
        }
        setOn()
        toggleAction?()
        return
    }
    
    func setOn(){
        
        isStatusActive = true
        UIView.animate(withDuration: 0.25) {
            
            self.leadingCircleConstraint?.priority = UILayoutPriority(rawValue: 250.0)
            self.layoutIfNeeded()
        }
        self.backgroundColor = UIColor(red: 250.0/255.0, green: 165.0/255.0, blue: 122.0/255.0, alpha: 1)
        self.circleView?.backgroundColor = UIColor.white
    }
    
    func setOff(){
        
        isStatusActive = false
        UIView.animate(withDuration: 0.25) {
            
            self.leadingCircleConstraint?.priority = UILayoutPriority(rawValue: 999.0)
            self.layoutIfNeeded()
        }
        self.backgroundColor = UIColor.white
        self.circleView?.backgroundColor = UIColor(red: 250.0/255.0, green: 165.0/255.0, blue: 122.0/255.0, alpha: 1)
        return
    }
}
