
//
//  LocalVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class LocalVideoView: VideoView {
    
    @IBOutlet private var leftConstraint : NSLayoutConstraint?
    @IBOutlet private var rightConstraint : NSLayoutConstraint?
    @IBOutlet private var topConstraint : NSLayoutConstraint?
    

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
        
       
    }
    
    func makeSmall(){
        layoutIfNeeded()
        updateSizeConstraints(priority : 1.0)
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        
    }
    
    func makeLarge(){
        layoutIfNeeded()
        updateSizeConstraints(priority : 999.0)
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
    }
    
    private func updateSizeConstraints(priority : Float) {
        leftConstraint?.priority = UILayoutPriority(rawValue : priority)
        rightConstraint?.priority = UILayoutPriority(rawValue : priority)
        topConstraint?.priority = UILayoutPriority(rawValue : priority)
    }
    
    
    private func paintInterface(){
        self.clipsToBounds = true
        
        let maskLayer = CAShapeLayer()
        let frame = self.bounds
        
        let cornerRadius = CGFloat(5.0)
        maskLayer.path = UIBezierPath.init(roundedRect: frame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        maskLayer.frame = frame
        
        self.layer.mask = maskLayer
    }
    
    /*
     -(void)paintLocalView{
     
     [self.localView setClipsToBounds:true];
     //    [[self layer] setCornerRadius:[self frame].size.height/2];
     
     CAShapeLayer * maskLayer = [CAShapeLayer layer];
     CGRect frame = self.localView.bounds;
     float cornerRadius = 5.0;
     maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:frame  byRoundingCorners: UIRectCornerAllCorners cornerRadii: CGSizeMake(cornerRadius, cornerRadius)].CGPath;
     maskLayer.frame = self.localView.bounds;
     self.localView.layer.mask = maskLayer;
     }
     */
    
}
