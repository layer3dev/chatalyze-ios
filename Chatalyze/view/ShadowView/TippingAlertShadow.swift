//
//  TippingAlertShadow.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//
import UIKit
import QuartzCore


class TippingAlertShadow: UIView {

    override var bounds: CGRect{
        didSet{
            setupShadow()
        }
    }

    private func setupShadow() {
        //Log.echo(key: "yud", text: "Bounds changed")
        self.dropShadow(color: UIColor.lightGray, opacity: 0.5, offSet: CGSize.zero, radius: 8, scale: true)
    }

}


extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize = CGSize.zero, radius: CGFloat = 1, scale: Bool = true) {
        
        //Radius must be same as the cornerRadius required for UIView and maskToBounds and clipsToBound mus  be false
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
