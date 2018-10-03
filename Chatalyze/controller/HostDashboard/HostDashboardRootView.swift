//
//  HostDashboardRootView.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class HostDashboardRootView: MySessionRootView {
    
    @IBOutlet var underLineLbl:UILabel?
    var fontSize:CGFloat = 16.0
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        initializeFontSize()
        underLineLable()
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: fontSize)] as? [NSAttributedStringKey : Any]{
         
            let underlineAttributedString = NSAttributedString(string: "TEST MY PHONE", attributes: underlineAttribute as [NSAttributedStringKey : Any])
            underLineLbl?.attributedText = underlineAttributedString
        }
    }
}
