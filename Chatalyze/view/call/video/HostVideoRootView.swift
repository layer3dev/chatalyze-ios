

//
//  HostVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 07/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class HostVideoRootView: VideoRootView {
    
    @IBOutlet var canvasContainer : CanvasHostContainer?
    @IBOutlet var callInfoContainer : HostCallInfoContainerView?
    @IBOutlet var signatureAccessoryViewBottomConstraint:NSLayoutConstraint?
    
    var canvas : AutographyHostCanvas?{
        get{
            return canvasContainer?.canvas
        }
    }
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func shouldTapAllow(touch: UITouch) -> Bool {
        
        Log.echo(key: "point", text: "TOUCH CANVAS IS \(touch.location(in: self.canvas?.mainImageView)) doest exists the touch ")
        
        if self.canvas?.mainImageView?.frame.contains(touch.location(in: self)) ?? false{
            return false
        }
        return true
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
       // canvasContainer?.delegate = self
    }

    
    override func animateHeader() {
        
        if isStatusBarhiddenDuringAnimation == false {
            
            self.delegateCutsom?.visibleAnimateStatusBar()
            isStatusBarhiddenDuringAnimation = true
            UIView.animate(withDuration: 0.25) {
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+10.0)
//                self.signatureAccessoryViewBottomConstraint?.constant = 0
                self.layoutIfNeeded()
            }
            return
        }
        
        isStatusBarhiddenDuringAnimation = false
        self.delegateCutsom?.hidingAnimateStatusBar()
        UIView.animate(withDuration: 0.25) {
            
            self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+10.0)
//            self.signatureAccessoryViewBottomConstraint?.constant = -150
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func crossAccessoryView(sender:UIButton?){
        self.actionContainer?.toggleContainer()
        self.animateHeader()
    }
}
