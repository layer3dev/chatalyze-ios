//
//  SelfieActionContainerView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 21/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation

class SelfieActionContainerView: ExtendedView {
    
    var reatkeConatainerWidth : CGFloat = 120
    var saveConatinerWidth : CGFloat = 120
    
    @IBOutlet weak var retakeContainerWidthAnchor : NSLayoutConstraint?
    @IBOutlet weak var saveContainerWidthAnchor : NSLayoutConstraint?
    @IBOutlet weak var selfieActionContainerWidthAnchor : NSLayoutConstraint?
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    private func enableCamera(){
        self.disableRetakeAndSave()
        if  UIDevice.current.userInterfaceIdiom == .pad{
            selfieActionContainerWidthAnchor?.constant = 70
        }else{
            selfieActionContainerWidthAnchor?.constant = 50
        }
  
    }
    
    private func enableRetakeAndSave(){
        self.disableCamera()
        if  UIDevice.current.userInterfaceIdiom == .pad{
            self.retakeContainerWidthAnchor?.constant = reatkeConatainerWidth
            self.saveContainerWidthAnchor?.constant = reatkeConatainerWidth
        }else{
            self.retakeContainerWidthAnchor?.constant = 90
            self.saveContainerWidthAnchor?.constant = 90
        }
    }
    
    private func disableCamera(){
        self.selfieActionContainerWidthAnchor?.constant = 0
    }
    
    private func disableRetakeAndSave(){
        self.retakeContainerWidthAnchor?.constant = 0
        self.saveContainerWidthAnchor?.constant = 0
    }
    
}
