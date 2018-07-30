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
    
    @IBOutlet var leadingSpace : NSLayoutConstraint?
    
    let hiddenPaddingValue = -40.0
    let visiblePaddingValue = 8.0

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
        
        guard let leadingSpace = self.leadingSpace
            else{
                return
        }
        
        if(leadingSpace.constant == CGFloat(visiblePaddingValue)){
            self.leadingSpace?.constant = CGFloat(hiddenPaddingValue)
//            self.alpha = 0.0
            return
        }
        
        self.leadingSpace?.constant = CGFloat(visiblePaddingValue)
//        self.alpha = 1.0
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
