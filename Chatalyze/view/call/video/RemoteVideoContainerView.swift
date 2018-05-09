//
//  RemoteVideoContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 09/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class RemoteVideoContainerView: ExtendedView {

    @IBOutlet var remoteVideoView : RemoteVideoView?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        remoteVideoView?.updateContainerSize(containerSize: self.bounds.size)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }

}
