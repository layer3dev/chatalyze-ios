//
//  CanvasContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CanvasContainer: ExtendedView {
    
    @IBOutlet var canvas : AutographyCanvas?
    @IBOutlet var canvasHeightZeroConstraint : NSLayoutConstraint?
    @IBOutlet var canvasProportionalHeightConstraint : NSLayoutConstraint?

    @IBOutlet var canvasBottomToSignConstraint : NSLayoutConstraint?
    @IBOutlet var canvasBottomToRootConstraint : NSLayoutConstraint?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func show(){
        
        layoutIfNeeded()
        
        showInPortrait()
        
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
    
    
    private func showInPortrait(){
       
        canvasHeightZeroConstraint?.priority = UILayoutPriority(1.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(990.0)
        
        canvasBottomToSignConstraint?.priority = UILayoutPriority(990.0)
        canvasBottomToRootConstraint?.priority = UILayoutPriority(1.0)
        
    }
    
    private func hideCanvas(){
     
        canvasHeightZeroConstraint?.priority = UILayoutPriority(990.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(1.0)
        
        canvasBottomToSignConstraint?.priority = UILayoutPriority(1.0)
        canvasBottomToRootConstraint?.priority = UILayoutPriority(990.0)
        
    }
    
    func hide(){
        
        layoutIfNeeded()
        hideCanvas()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
}
