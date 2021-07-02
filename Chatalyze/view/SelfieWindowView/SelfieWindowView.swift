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
    @IBOutlet weak var streamStackViews  : UIStackView?
    @IBOutlet weak var selfieActionContainer : SelfieActionContainerView?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
        
    func setSelfieImage(with image:UIImage?){
        
    }
    
    func show( with mediaPackage : CallMediaTrack?,remoteStream : RemoteVideoTrack?){
      
    }
    
    func hide(){
        self.isHidden = true
    }
    
    func showLocal(localMediaPackage : CallMediaTrack?){
        self.streamStackViews?.isHidden = false
        self.finalMemoryImg?.image = nil
        
    }
    
    @IBAction func closePhotoBooth(){
        releaseDeviceOrientation()
        self.finalMemoryImg?.image = nil
        hide()
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
          
        }

        if UIDevice.current.orientation.isPortrait {
            print("Portrait")
        
        }
    }
    
    func releaseDeviceOrientation(){
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.isSignatureInCallisActive = false
        delegate?.allowRotate = true
    }
    
}
