//
//  RemoteVideoContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 09/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class RemoteVideoContainerView: ExtendedView {
    
    @IBOutlet var remoteVideoView : RemoteVideoView?
    
    //Constraints responsible when signature is not initiated and it will be same in both the screen modes Portrait and Landscape.
    
    @IBOutlet  var leadingMain : NSLayoutConstraint?
    @IBOutlet  var trailingMain : NSLayoutConstraint?
    @IBOutlet  var topMain : NSLayoutConstraint?
    @IBOutlet  var bottomMain : NSLayoutConstraint?
    
    //Constraints that handles the portrait on the Signature call
    
    @IBOutlet var topAlignedToLocalView:NSLayoutConstraint?
    @IBOutlet var horizontalSpacingToLocalView:NSLayoutConstraint?
   
    @IBOutlet var widthOfRemote:NSLayoutConstraint?
    @IBOutlet var heightOfRemote:NSLayoutConstraint?
    
    // Constraint in the landscape mode for the
    @IBOutlet var trailingAlignedToLocalView:NSLayoutConstraint?
    @IBOutlet var verticalSpacingToLocalView:NSLayoutConstraint?
        
    //Two constraints using the same as above equalWidthToLocal and equalHeightToLocal
    var isSignatureActive:Bool = false
    var isStreamPortraitPosition:Bool = true
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        self.initialization()
        self.remoteVideoView?.streamUpdationDelegate = self
    }

    private func paintCorners(){
        
        self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.layer.masksToBounds = true
    }
    
    func resetCorners(){
      
        self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 0:0
        self.layer.masksToBounds = false
    }
    
    func initialization(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func didRotate() {
        
        self.updateLayoutRotation()
    }
    
    func updateLayoutRotation() {
        
        if isSignatureActive{
        
            self.signatureScreenSetup()
            return
        }
        self.updateForCall()
        return
    }
    
    func resetConstraints(){
                
        leadingMain?.isActive = false
        trailingMain?.isActive = false
        topMain?.isActive = false
        bottomMain?.isActive = false
        
        //Constraints that handles the portrait on the Signature call
        topAlignedToLocalView?.isActive = false
        horizontalSpacingToLocalView?.isActive = false
        widthOfRemote?.isActive = false
        widthOfRemote?.isActive = false
        
        //Constraint in the landscape mode for the
        trailingAlignedToLocalView?.isActive = false
        verticalSpacingToLocalView?.isActive = false

        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    
    func updateForSignature(){
        
        Log.echo(key: "rotation" ,text: "my orientation in remote view is  \(UIDevice.current.orientation)")
        
        //This method is required to call during the first time initialization of the screen as the screenshot appears at this time handling flat position is also required to the handle.
        
        self.signatureScreenSetup()
    }
        
    
    func signatureScreenSetup(){
        
        self.paintCorners()
        if UIDevice.current.orientation.isLandscape {
            
            // Constraint in the landscape mode for the
            Log.echo(key: "rotation" ,text: "is landscape is Calling in remote video view and the stream position is \(isStreamPortraitPosition)")
            
            resetConstraints()
            self.widthOfRemote?.isActive = true
            self.heightOfRemote?.isActive = true
            self.trailingAlignedToLocalView?.isActive = true
            self.verticalSpacingToLocalView?.isActive = true
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                if isStreamPortraitPosition{
                    
                    heightOfRemote?.constant = 224
                    //heightOfRemote?.constant = 126
                    widthOfRemote?.constant = 126
                    
                }else{
                    
                    heightOfRemote?.constant = 126
                    widthOfRemote?.constant = 224
                }
            }else{
                
                if isStreamPortraitPosition{
                    
                    heightOfRemote?.constant = 112
                    //widthOfRemote?.constant = 63
                    widthOfRemote?.constant = 63
                    
                }else{
                    
                    heightOfRemote?.constant = 72
                    widthOfRemote?.constant = 128
                }
            }
            return
        }
        
        if UIDevice.current.orientation.isPortrait {
            
            // Constraints that handles the portrait on the Signature call
            
            Log.echo(key: "rotation" ,text: "is portrait is Calling in remotevideo view")
            
            resetConstraints()
            topAlignedToLocalView?.isActive = true
            horizontalSpacingToLocalView?.isActive = true
            widthOfRemote?.isActive = true
            heightOfRemote?.isActive = true
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                if isStreamPortraitPosition{
                    
                    heightOfRemote?.constant = 224
                    widthOfRemote?.constant = 126
                    
                }else{
                    
                    heightOfRemote?.constant = 126
                    widthOfRemote?.constant = 224
                }
            }else{
                
                if isStreamPortraitPosition{
                    
                    heightOfRemote?.constant = 112
                    widthOfRemote?.constant = 63
                    
                }else{
                    
                    //given by me
                    heightOfRemote?.constant = 72
                    widthOfRemote?.constant = 128
                    
                }
            }
            return
        }
        
        if UIDevice.current.orientation.isFlat{
            
            Log.echo(key: "rotation" ,text: "is Flat is Calling in remote video view")

            if UIApplication.shared.statusBarOrientation.isPortrait {
              
                Log.echo(key: "rotation" ,text: "is Flat portrait is Calling in remote video view")
                Log.echo(key: "rotation" ,text: " and the stream position is \(isStreamPortraitPosition)")

                resetConstraints()
                topAlignedToLocalView?.isActive = true
                horizontalSpacingToLocalView?.isActive = true
                widthOfRemote?.isActive = true
                heightOfRemote?.isActive = true
                
                if UIDevice.current.userInterfaceIdiom == .pad{
                    
                    if isStreamPortraitPosition{
                        
                        heightOfRemote?.constant = 224
                        widthOfRemote?.constant = 126
                    }else{
                        
                        heightOfRemote?.constant = 126
                        widthOfRemote?.constant = 224
                    }
                }else{
                    
                    if isStreamPortraitPosition {
                        
                        heightOfRemote?.constant = 112
                        widthOfRemote?.constant = 63
                    }else{
                        
                        heightOfRemote?.constant = 72
                        widthOfRemote?.constant = 128
                    }
                }
                return
            }else{
                
                Log.echo(key: "rotation" ,text: "is Flat landscape is Calling in remote video view")

                Log.echo(key: "rotation" ,text: " and the stream position is \(isStreamPortraitPosition)")

                resetConstraints()
                self.widthOfRemote?.isActive = true
                self.heightOfRemote?.isActive = true
                self.trailingAlignedToLocalView?.isActive = true
                self.verticalSpacingToLocalView?.isActive = true
                
                if UIDevice.current.userInterfaceIdiom == .pad{
                    
                    if isStreamPortraitPosition{
                        
                        heightOfRemote?.constant = 224
                        //widthOfRemote?.constant = 126
                        widthOfRemote?.constant = 126
                        
                    }else{
                        
                        heightOfRemote?.constant = 126
                        widthOfRemote?.constant = 224
                    }
                }else{
                    
                    if isStreamPortraitPosition{
                        
                        heightOfRemote?.constant = 112
                        widthOfRemote?.constant = 63
                        //widthOfRemote?.constant = 128
                        
                    }else{
                        
                        heightOfRemote?.constant = 72
                        widthOfRemote?.constant = 128
                    }
                }
                return
            }
        }
    }
    
    
    func updateForCall(){
        
        self.resetConstraints()
        self.resetCorners()
        self.leadingMain?.isActive = true
        self.trailingMain?.isActive = true
        self.topMain?.isActive = true
        self.bottomMain?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        remoteVideoView?.updateContainerSize(containerSize: self.bounds.size)
    }
}


extension RemoteVideoContainerView:UpdateStreamChangeProtocol{
   
    func updateForStreamPosition(isPortrait:Bool){
        
        Log.echo(key: "rotation", text: "Stream updation is \(isPortrait)")
        
        isStreamPortraitPosition = isPortrait
        
        if !isSignatureActive{
            return
        }
        self.signatureScreenSetup()
    }
    
    func getContainerSize()->CGSize{
        return self.frame.size
    }
}
