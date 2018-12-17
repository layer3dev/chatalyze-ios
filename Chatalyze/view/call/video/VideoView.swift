//
//  VideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit


class VideoView: RTCEAGLVideoView {
    
    private var trackSize : CGSize = CGSize.zero

    enum orientation : Int{
        
        case undefined = 0
        case portrait = 1
        case landscape = 2
    }
    
    private var isLoaded = false;
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if(!isLoaded){
            
            isLoaded = true
            viewDidLayout()
        }
    }

    func viewDidLayout(){
        
        initialization()
    }

    private func initialization(){
        
         self.delegate = self
    }
    
    func updateSize(size: CGSize){
    }
}

extension VideoView : RTCVideoViewDelegate{
    
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        Log.echo(key: "render", text: "didChangeVideoSize --> \(size)")
        if(size != CGSize.zero){
            self.trackSize = size
        }
        
        self.updateSize(size: size)
    }
    
    
}
