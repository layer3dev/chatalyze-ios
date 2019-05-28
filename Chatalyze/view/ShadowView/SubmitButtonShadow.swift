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
    
    override var bounds: CGRect{
        didSet{
            setupShadow()
        }
    }
    
    private func setupShadow() {
        
        let radius:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 6:4        
        //Log.echo(key: "yud", text: "Bounds changed")
        self.dropShadow(color: UIColor.lightGray, opacity: 1, offSet: CGSize.zero, radius: radius, scale: true)
    }
}
