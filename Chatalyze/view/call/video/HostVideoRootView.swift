

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
    @IBOutlet var hostCallInfoContainer : HostCallInfoContainerView?
    @IBOutlet var signatureAccessoryViewBottomConstraint:NSLayoutConstraint?
    
    var canvas : AutographyHostCanvas?{
        get{
            return canvasContainer?.getCanvasReference()
        }
    }
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    override func mergeImage(hostPicture : UIImage, userPicture : UIImage)->UIImage?{
        
        let size = hostPicture.size
        let localSize = userPicture.size
        
        let maxConstant = size.width > size.height ? size.width : size.height
        
        let localContainerSize = CGSize(width: maxConstant/4, height: maxConstant/4)
        
        let aspectSize = AVMakeRect(aspectRatio: localSize, insideRect: CGRect(origin: CGPoint.zero, size: localContainerSize))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        userPicture.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //local.draw(in: CGRect(x: (size.width - aspectSize.width+20), y: (size.height - aspectSize.height), width: aspectSize.width, height: aspectSize.height))
        
        hostPicture.draw(in: CGRect(x: (size.width - aspectSize.width-10), y: 10, width: aspectSize.width, height: aspectSize.height))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return finalImage
    }
        
    override func shouldTapAllow(touch: UITouch) -> Bool {
        
        Log.echo(key: "yud", text: "self self.canvasContainer?.isSignatureActive is \(self.canvasContainer?.isSignatureActive)")
        
        if self.canvasContainer?.isSignatureActive == true{
            return false
        }
        return true
        
        
//        Log.echo(key: "yud", text: "touch loacation is \(touch.location(in: self)) and self.view frame is \(self.frame) and main image frame is \(self.canvas?.mainImageView?.frame)")
//
//
//
//        Log.echo(key: "point", text: "TOUCH CANVAS IS \(touch.location(in: self.canvas?.mainImageView)) doest exists the touch and exists is \(self.canvas?.mainImageView?.frame.contains(touch.location(in: self)))")
//
//        if self.canvas?.mainImageView?.frame.contains(touch.location(in: self)) ?? false{
//            return false
//        }
//        return true
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
                                                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5.0)

                self.layoutIfNeeded()
            }
            return
        }
        
        isStatusBarhiddenDuringAnimation = false
        
        var isNotch = false
        var notchHeight:CGFloat = 0.0
        
        print("updated height ios \(UIApplication.shared.statusBarFrame.size.height)")
        
        if (UIApplication.shared.statusBarFrame.size.height > 21.0) && (UIDevice.current.userInterfaceIdiom == .phone){
            
            isNotch = true
            notchHeight = UIApplication.shared.statusBarFrame.size.height
        }
        
        self.delegateCutsom?.hidingAnimateStatusBar()
        UIView.animate(withDuration: 0.25) {
                        
            if isNotch == true{
                
                print("showing notch device")
                self.headerTopConstraint?.constant = (notchHeight+5.0)
                self.layoutIfNeeded()

            }else{
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5.0)
                self.layoutIfNeeded()

            }

                        
//            self.layoutIfNeeded()
        }
    }
    
    @IBAction func crossAccessoryView(sender:UIButton?){
        self.actionContainer?.toggleContainer()
        self.animateHeader()
    }
}
