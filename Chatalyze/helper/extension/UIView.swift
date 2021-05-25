



//
//  View.swift
//  GGStaff
//
//  Created by Sumant Handa on 05/09/16.
//  Copyright © 2016 GenGold. All rights reserved.
//

import Foundation
import UIKit


public extension UIView {
    
    
    func addConstraints(childView : UIView){
        
        let metrics = [String : Int]()
        let viewInfos = ["childView" : childView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[childView]-0-|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewInfos))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[childView]-0-|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewInfos))
        
    }
    
    func addBottomConstraint(bottom : CGFloat = 0, childView : UIView)->NSLayoutConstraint?{
        
        var metrics = [String : CGFloat]()
        metrics["bottom"] = bottom
        let viewInfos = ["childView" : childView]
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[childView]-bottom-|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewInfos)
         self.addConstraints(constraints)
        return constraints[0]
    }
    
    
    
    
    func addCenterConstraints(childView : UIView) {
        
        addCenterHorizontalConstraint(childView: childView)
        addCenterVerticalConstraint(childView: childView)
    }
    
    func addCenterHorizontalConstraint(childView : UIView){
        
        let metrics = [String : Int]()
        childView.translatesAutoresizingMaskIntoConstraints = false
        let viewInfos = ["childView" : childView, "superview" : self]
        // Center horizontally
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[superview]-(<=1)-[childView]",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
            metrics: metrics,
            views: viewInfos)
        self.addConstraints(constraints)
    }
    
    @objc func addCenterVerticalConstraint(childView : UIView){
        
        let metrics = [String : Int]()
        childView.translatesAutoresizingMaskIntoConstraints = false
        let viewInfos = ["childView" : childView, "superview" : self]
        
        // Center vertically
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[childView]",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterY,
            metrics: metrics,
            views: viewInfos)
        
        self.addConstraints(constraints)
    }
    
    @objc func addWidthConstraint(width : CGFloat){
        let metrics = [String : Int]()
        let viewInfos = ["self" : self]
        let constraint = String(format : "H:[self(%f)]", width)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewInfos))
        
    }
    
    @objc func addHeightConstraint(height : CGFloat){
        
        let metrics = [String : Int]()
        let viewInfos = ["self" : self]
        let constraint = String(format : "V:[self(%f)]", height)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewInfos))
    }
    
}

extension UIView {
    @objc func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
