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

    override func viewDidLayout() {
        super.viewDidLayout()
    }
        
    func setSelfieImage(with image:UIImage?){
        
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        self.finalMemoryImg?.image = image
        self.streamStackViews?.isHidden = true
    }
    
    func show(){
        self.isHidden = false
    }
    
    func hide(){
        self.isHidden = true
    }
    
    func showLocal(localMediaPackage : CallMediaTrack?){
        self.streamStackViews?.isHidden = false
        self.finalMemoryImg?.image = nil
        
        
    }
    
    @IBAction func closePhotoBooth(){
        self.finalMemoryImg?.image = nil
        hide()
    }
    
    
    
}
