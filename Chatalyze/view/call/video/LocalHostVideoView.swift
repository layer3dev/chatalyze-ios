//
//  LocalHostVideoView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 20/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class LocalHostVideoView: LocalVideoView {
    
    //During the signature on calling the portrait mode
    @IBOutlet var userTopForProtraitOnSignature:NSLayoutConstraint?
    @IBOutlet var userLeadingForProtraitOnSignature:NSLayoutConstraint?

    //During the signature on calling the landscape mode
    //simple bottom will work for that
    @IBOutlet var userTrailingForLandscapeOnSignatureNSimpleCall:NSLayoutConstraint?
    
    @objc override func didRotate(){
        
        updateLayoutRotation()
    }
    
    
    override func updateLayoutRotation() {
        
        if(UIDevice.current.orientation.isFlat){
            //updateForPortrait()
            return
        }
        
        if (UIDevice.current.orientation.isLandscape) {
            updateForLandscape()
        } else {
            updateForPortrait()
        }
    }
    
    
    override var isIPad : Bool{
        get{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    override func updateForPortrait(){
        
        if isSignatureActive{
            
            resetConstraints()
            self.userTopForProtraitOnSignature?.isActive = true
            self.userLeadingForProtraitOnSignature?.isActive = true
            
            if(isIPad){
                
                heightConstraint?.constant = 224
                widthConstraint?.constant = 126
                return
            }
            
            heightConstraint?.constant = 112
            widthConstraint?.constant = 63
            return
        }
        
        resetConstraints()
        topConstraint?.isActive = true
        bottomConstraint?.isActive = false
        userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = true

        
        if(isIPad){
            
            heightConstraint?.constant = 224
            widthConstraint?.constant = 126
            return
        }
        
        heightConstraint?.constant = 112
        widthConstraint?.constant = 63
        return
    }
    
    override func updateForLandscape(){
        
        if isSignatureActive{
            
            resetConstraints()
            bottomConstraint?.isActive = true
            userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = true
            userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = true
            if(isIPad){
                
                heightConstraint?.constant = 126
                widthConstraint?.constant = 224
                return
            }
            
            heightConstraint?.constant = 72
            widthConstraint?.constant = 128
            return
        }
        
        resetConstraints()
        topConstraint?.isActive = false
        bottomConstraint?.isActive = true
        userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = true

        if(isIPad){
            
            heightConstraint?.constant = 126
            widthConstraint?.constant = 224
            return
        }
        
        heightConstraint?.constant = 72
        widthConstraint?.constant = 128
        return
    }
    
    func resetConstraints(){
        
        self.userTopForProtraitOnSignature?.isActive = false
        self.userLeadingForProtraitOnSignature?.isActive = false
        self.userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = false
        self.topConstraint?.isActive = false
        self.bottomConstraint?.isActive = false
    }

}
