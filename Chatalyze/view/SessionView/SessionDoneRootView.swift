//
//  SessionDoneRootView.swift
//  Chatalyze
//
//  Created by Mansa on 27/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionDoneRootView:ExtendedView{
    
    @IBOutlet var underlineLabel:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        underLineLable()
    }
    
    
    func underLineLable(){
        
        let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "https://dev.chatalyze.com/sessions/Chat-Session/3459", attributes: underlineAttribute as [NSAttributedStringKey : Any])
        underlineLabel?.attributedText = underlineAttributedString
    }
}




