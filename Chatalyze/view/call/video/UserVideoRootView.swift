//
//  UserVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage
import YoutubePlayer_in_WKWebView


class UserVideoRootView: UserVideoLayoutView {
    
    
    @IBOutlet var requestAutographButton : RequestAutographContainerView?
    @IBOutlet var userCallInfoContainer : UserCallInfoContainerView?
    var extractor : FrameExtractor?
    @IBOutlet var youtubeContainerView : YoutubeContainerView?

    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     
     */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    
    }
    
    
    
    
    
    
    
    
    override func mergePicture(local : UIImage, remote : UIImage) -> UIImage?{
        return self.mergeImage(hostPicture: remote, userPicture: local)
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
                
                print("showin notch device ")
                self.headerTopConstraint?.constant = (notchHeight+5.0)
                
            }else{
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5.0)
            }
            
            self.layoutIfNeeded()
        }
    }
    
    
}



