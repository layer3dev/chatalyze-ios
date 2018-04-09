//
//  UserVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserVideoRootView: VideoRootView {
    
    @IBOutlet var canvas : AutographyCanvas?
    @IBOutlet var requestAutographButton : RequestAutographContainerView?
    
    @IBOutlet var canvasHeightConstraint : NSLayoutConstraint?
    @IBOutlet var callInfoContainer : UserCallInfoContainerView?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func getSnapshot()->UIImage?{
        
        let bounds = self.bounds ?? CGRect()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var canvasHeight : CGFloat{
        let height = 0.4 * self.bounds.size.height
        return height
    }
    
    func showCanvas(){
        layoutIfNeeded()
        canvasHeightConstraint?.constant = canvasHeight
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        
    }
    
    func hideCanvas(){
        layoutIfNeeded()
        canvasHeightConstraint?.constant = 0
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
    

}
