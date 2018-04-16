
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
    }
    
    override func updateSize(size: CGSize){
        let screenSize = UIScreen.main.bounds
        let containerSize = CGSize(width: screenSize.width/4, height: screenSize.height/4)
        
        let aspectSize = AVMakeRect(aspectRatio: size, insideRect: CGRect(origin: CGPoint.zero, size: containerSize))
        
        updateViewSize(size : aspectSize.size)
    }
    
    private func updateViewSize(size: CGSize){
        self.layoutIfNeeded()
        self.widthConstraint?.constant = size.width
        self.heightConstraint?.constant = size.height
        
        UIView.animate(withDuration: 1.0, animations: {
            self.layoutIfNeeded()
        }) { (success) in
            
        }
    }
   
    
   
    
   
    
}
