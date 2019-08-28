//
//  AccountHostRootView.swift
//  Chatalyze
//
//  Created by Mansa on 26/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class AccountHostRootView:AccountRootView{
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    //Here memory stands for setting and the mytickets stand for Session
    override func setTabInterface(controller:UIViewController?){
        
        guard let controller = controller else { return }
        
        if controller.isKind(of: SettingController.self){
            
            resetColor()
            memoriesView?.backgroundColor = UIColor(hexString: AppThemeConfig.themeColor)
            memoriesLbl?.textColor = UIColor.white
            
        }else if controller.isKind(of: SessionController.self){
            
            resetColor()
            myTicketView?.backgroundColor = UIColor(hexString: AppThemeConfig.themeColor)
            myTicketLbl?.textColor = UIColor.white
            
        }
    }
}

