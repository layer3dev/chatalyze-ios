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
        navigationBarAppearace.tintColor = AppThemeConfig.navigationBarColor
        navigationBarAppearace.barTintColor = AppThemeConfig.navigationBarColor
        navigationBarAppearace.isTranslucent = false
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes =  [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    func updateStatusBar(){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
}
