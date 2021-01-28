
//
//  LocalVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

//AVMakeRectWithAspectRatioInsideRect
class LocalVideoView: VideoViewOld {
    
    private let TAG = "LocalVideoView"
    
    private var frameRender = CameraVideoFrameRenderer()
    
    @IBOutlet var widthConstraint : NSLayoutConstraint?
    @IBOutlet var heightConstraint : NSLayoutConstraint?
    
    @IBOutlet var topConstraint : NSLayoutConstraint?
    @IBOutlet var bottomConstraint : NSLayoutConstraint?
    
    var getLocalImage:((UIImage?)->())?

    var isSignatureActive:Bool = false
    
    //    override var TAG : String{
    //        get{
    //            return "LocalVideoView"
    //        }
    //    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func getRenderer() -> VideoFrameRenderer{
        return frameRender
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    override func paintInterface() {
        
        self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.layer.masksToBounds = true
    }
    
    private func initialization(){
        
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        updateLayoutRotation()
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func didRotate(){
        
        updateLayoutRotation()
    }
    
    
    func updateLayoutRotation() {
        Log.echo(key: TAG, text: "updateLayoutRotation")
        if(UIDevice.current.orientation.isFlat){
            Log.echo(key: TAG, text: "isFlat")
            if UIApplication.shared.statusBarOrientation.isLandscape{
                Log.echo(key: TAG, text: "isFlat updateForLandscape")
                updateForLandscape()
            }else{
                Log.echo(key: TAG, text: "isFlat updateForPortrait")
                updateForPortrait()
            }
            return
        }

        if (UIDevice.current.orientation.isLandscape) {
            Log.echo(key: TAG, text: "isLandscape")
            updateForLandscape()
            return
        }
        if(UIDevice.current.orientation.isPortrait) {
            Log.echo(key: TAG, text: "isPortrait")
            updateForPortrait()
            return
        }
    }
    
    var isIPad : Bool{
        get{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    func updateForPortrait(){
        
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
    
    func updateForLandscape(){
       
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
    
    
    override func updateSize(size: CGSize) {
        super.updateSize(size: size)
    }
}
