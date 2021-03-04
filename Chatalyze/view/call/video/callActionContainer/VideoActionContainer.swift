//
//  VideoActionContainer.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoActionContainer: ExtendedView {
    
    @IBOutlet var audioView : MicActionView?
    @IBOutlet var videoView : VideoActionView?
    
    @IBOutlet var bottomSpace : NSLayoutConstraint?
    @IBOutlet var extendChatView : ExtendChatView?
    
    var isactionContainerVisible = true
    
    let hiddenPaddingValue = -100.0
    let visiblePaddingValue = 15.0
    
    let hiddenPaddingValueiPad = -120.0
    let visiblePaddingValueiPad = 30.0

    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
    }
    
    func toggleContainer(){
        
        weak var weakSelf = self
        self.layoutIfNeeded()
        self.animateContainerVisibility()
        UIView.animate(withDuration: 1.0) {
            weakSelf?.layoutIfNeeded()
        }
    }
    
    private func animateContainerVisibility(){
        
        guard let bottomSpace = self.bottomSpace
            else{
                return
        }
        
        //For iPhone
        if UIDevice.current.userInterfaceIdiom == .phone{
            
            //if(bottomSpace.constant == CGFloat(visiblePaddingValue)){
            if isactionContainerVisible{
                self.isactionContainerVisible = false
                self.bottomSpace?.constant = CGFloat(hiddenPaddingValue)
                //self.alpha = 0.0
                return
            }
            self.isactionContainerVisible = true
            self.bottomSpace?.constant = CGFloat(visiblePaddingValue)
            //self.alpha = 1.0
            return
        }
        
        
        //For iPad
        //if(bottomSpace.constant == CGFloat(visiblePaddingValueiPad)){
        if isactionContainerVisible{
            self.isactionContainerVisible = false
            self.bottomSpace?.constant = CGFloat(hiddenPaddingValueiPad)
            //self.alpha = 0.0
            return
        }
        self.isactionContainerVisible = true
        self.bottomSpace?.constant = CGFloat(visiblePaddingValueiPad)
    }
    
    /*
     -(void)addOptionToggleGesture{
     //Add Tap to hide/show controls
     UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleButtonContainer)];
     [tapGestureRecognizer setNumberOfTapsRequired:1];
     [self.view addGestureRecognizer:tapGestureRecognizer];
     }
     
     - (void)toggleButtonContainer {
     [UIView animateWithDuration:0.3f animations:^{
     if (self.optionContainerLeadingSpace.constant <= -40.0f) {
     [self.optionContainerLeadingSpace setConstant:8.0f];
     [self.optionContainerView setAlpha:1.0f];
     } else {
     [self.optionContainerLeadingSpace setConstant:-40.0f];
     [self.optionContainerView setAlpha:0.0f];
     }
     [self.view layoutIfNeeded];
     }];
     }
     */

}
