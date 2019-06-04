//
//  TestMyPhoneShadow.swift
//  Chatalyze
//
//  Created by mansa infotech on 03/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import QuartzCore

class TestMyPhoneShadow: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupShadow()
    }

    private func setupShadow() {
        
        let radius:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        
        //Log.echo(key: "yud", text: "Bounds changed")
        self.dropShadow(color: UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1), opacity: 1, offSet: CGSize.zero, radius: radius, scale: true)
    }
}
