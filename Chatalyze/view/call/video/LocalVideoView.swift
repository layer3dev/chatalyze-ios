
//
//  LocalVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

//AVMakeRectWithAspectRatioInsideRect
class LocalVideoView: VideoView {
    
    @IBOutlet private var widthConstraint : NSLayoutConstraint?
    @IBOutlet private var heightConstraint : NSLayoutConstraint?
    
    @IBOutlet private var topConstraint : NSLayoutConstraint?
    @IBOutlet private var bottomConstraint : NSLayoutConstraint?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func viewDidLayout() {
        super.viewDidLayout()
        initialization()
    }
    
    
    private func initialization(){
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        updateLayoutRotation()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func didRotate(){
        updateLayoutRotation()
    }
    
    func updateLayoutRotation() {
        
        if(UIDevice.current.orientation.isFlat){
            return
        }
        
        if (UIDevice.current.orientation.isLandscape) {
            updateForLandscape()
        } else {
            updateForPortrait()
        }
    }
    
    
    var isIPad : Bool{
        get{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }

    private func updateForPortrait(){
        topConstraint?.isActive = true
        bottomConstraint?.isActive = false
        if(isIPad){
            heightConstraint?.constant = 224
            widthConstraint?.constant = 126
            return
        }
        
        heightConstraint?.constant = 112
        widthConstraint?.constant = 63
        return
    }
    
    private func updateForLandscape(){
        topConstraint?.isActive = false
        bottomConstraint?.isActive = true
        if(isIPad){
            heightConstraint?.constant = 126
            widthConstraint?.constant = 224
            return
        }
        
        heightConstraint?.constant = 72
        widthConstraint?.constant = 128
        return
    }
    
    
   
    
}
