//
//  TippingRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class TippingRootView: ExtendedView {
    
    @IBOutlet private var dollorOneView:UIView?
    @IBOutlet private var dollorTwoView:UIView?
    @IBOutlet private var dollorThreeView:UIView?
    @IBOutlet private var customTipView:UIView?
    @IBOutlet private var noTipView:UIView?
    @IBOutlet private var tipLabel:UILabel?
    @IBOutlet private var profileImage:UIImageView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintView()
    }
    
    func paintView(){
       
        profileImage?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 55:45
        profileImage?.layer.masksToBounds = true
        
        dollorOneView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorOneView?.layer.masksToBounds = true
        
        dollorTwoView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorTwoView?.layer.masksToBounds = true

        dollorThreeView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorThreeView?.layer.masksToBounds = true

        customTipView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        customTipView?.layer.masksToBounds = true

        noTipView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        noTipView?.layer.masksToBounds = true
    }
    
    func fillInfo(){
        
       //tipLabel?.text = "Would you like to support Jordan Winawer by giving a tip?"
    }
}
