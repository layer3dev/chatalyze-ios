//
//  LocalHostVideoView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 20/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class LocalHostVideoView: LocalVideoView {
    
    private let TAG = "LocalHostVideoView"
    
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
        Log.echo(key: TAG, text: "updateLayoutRotation")
        if(UIDevice.current.orientation.isFlat){
            
            Log.echo(key: TAG, text: "isFlat")
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                
                Log.echo(key: TAG, text: "isFlat landscape")
            
                Log.echo(key: "rotation", text: "rotation is of the landscape flat \(isSignatureActive)")
                updateForLandscape()
           
            }else{
                Log.echo(key: TAG, text: "isFlat portrait")
                Log.echo(key: "rotation", text: "rotation is of the portrait flat \(isSignatureActive)")
                updateForPortrait()
            }
            //updateForPortrait()
            return
        }

        if (UIDevice.current.orientation.isLandscape) {
            Log.echo(key: TAG, text: "landscape")
            
            Log.echo(key: "rotation", text: "rotation is of the landscape \(isSignatureActive)")
            updateForLandscape()
            return
            
        } else {
            
            Log.echo(key: TAG, text: "portrait")
            
            Log.echo(key: "rotation", text: "rotation is of the portrait and the signature is \(isSignatureActive)")
            updateForPortrait()
        }
    }
    
    
    override var isIPad : Bool{
        get{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    override func updateForPortrait(){
        
        Log.echo(key: TAG, text: "updateForPortrait")
        
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
        
        Log.echo(key: TAG, text: "updateForLandscape")
        
        if isSignatureActive{
            
            resetConstraints()
            topConstraint?.isActive = false
            bottomConstraint?.isActive = true
            userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = true
            
            if(isIPad){
                
                heightConstraint?.constant = 140
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
    
    func updateLayoutOnEndOfCall(){
       
        if UIDevice.current.orientation.isPortrait{
            
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
        if UIDevice.current.orientation.isLandscape{
           
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
        
        if UIDevice.current.orientation.isFlat{

            if UIApplication.shared.statusBarOrientation.isLandscape{
                
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
            
            if UIApplication.shared.statusBarOrientation.isPortrait{
                
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
        }
    }
    
    
    func resetConstraints(){
        
        self.userTopForProtraitOnSignature?.isActive = false
        self.userLeadingForProtraitOnSignature?.isActive = false
        self.userTrailingForLandscapeOnSignatureNSimpleCall?.isActive = false
        self.topConstraint?.isActive = false
        self.bottomConstraint?.isActive = false
    }

}
