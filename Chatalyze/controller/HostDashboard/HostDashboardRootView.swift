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
    
    override func viewDidLayout() {
        super.viewDidLayout()
      
        underLineLable()
    }
    
    func underLineLable(){
        
        let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "+TEST MY PHONE", attributes: underlineAttribute as [NSAttributedStringKey : Any])
        underLineLbl?.attributedText = underlineAttributedString
    }
}
