//
//  SelfieWindowView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 31/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import TwilioVideo

class SelfieWindowView:ExtendedView {
    
    @IBOutlet weak var hostStream : UIView?
    @IBOutlet weak var LocalStream : UIView?
    @IBOutlet weak var finalMemoryImg : UIImageView?
    @IBOutlet weak var localVideoView : LocalHostVideoView?
    @IBOutlet weak var retakeContainerWidthAnchor : NSLayoutConstraint?
    @IBOutlet weak var saveContainerWidthAnchor : NSLayoutConstraint?
    @IBOutlet weak var selfieActionContainerWidthAnchor : NSLayoutConstraint?

    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
        
    func setSelfieImage(with image:UIImage?){
        
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        self.finalMemoryImg?.image = image
    }
    
    func show(){
        self.isHidden = false
    }
    
    func hide(){
        self.isHidden = true
    }
    
    func showLocal(localMediaPackage : CallMediaTrack?){
        self.finalMemoryImg?.image = nil
        
//        localMediaPackage?.mediaTrack?.trackThree.videoTrack?.addRenderer(localPreviewView)
//        localMediaPackage?.mediaTrack?.trackThree.videoTrack?.addRenderer(renderer)
        
    }
    
    @IBAction func closePhotoBooth(){
        hide()
    }
    
    
    
}
