//
//  NavigationBarCustomizer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 24/02/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarCustomizer{
    
    init() {
        initialization()
    }
    
    fileprivate func initialization(){
        updateTint()
        updateStatusBar()
    }
    
    func updateTint(){
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(hexString: "#1c313a")
        navigationBarAppearace.barTintColor = UIColor(hexString: "#1c313a")
        navigationBarAppearace.isTranslucent = false
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes =  [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    func updateStatusBar(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
}
