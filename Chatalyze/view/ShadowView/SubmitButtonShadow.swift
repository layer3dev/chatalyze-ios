//
//  SubmitButtonShadow.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import QuartzCore

class SubmitButtonShadow: UIView {
  
    override func layoutSubviews(){
        super.layoutSubviews()
       
        self.setupShadow()
    }
    
    private func setupShadow() {
        
        let radius:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 6:4
        
        //Log.echo(key: "yud", text: "Bounds changed")
        self.dropShadow(color: UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1), opacity: 1, offSet: CGSize.zero, radius: radius, scale: true)
    }
}
