//
//  VideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoView: RTCEAGLVideoView {
    
    enum orientation : Int{
        case undefined = 0
        case portrait = 1
        case landscape = 2
    }
    
    private var isLoaded = false;
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!isLoaded){
            isLoaded = true
            viewDidLayout()
        }
    }
    
    func viewDidLayout(){
    }
    
    private func initialization(){
         //self.delegate = self
        
    }
}

extension VideoView : RTCEAGLVideoViewDelegate{
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
        
    }
    

}
