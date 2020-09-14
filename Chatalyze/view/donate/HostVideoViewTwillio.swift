//
//  HostVideoViewTwillio.swift
//  Chatalyze
//
//  Created by Yudhisther on 01/09/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

class HostVideoViewTwillio:VideoView{
    
    var isRequiredGetImageBuffer = true
    public var getImage:((Int)->())?
    var image:UIImage?
    
    override func renderFrame(_ frame: VideoFrame) {
        super.renderFrame(frame)
        
        print("self frame is \(frame)")
        
        if !isRequiredGetImageBuffer{
            isRequiredGetImageBuffer = false
            return
        }

       // self.yourImageView.image=[[UIImage alloc] initWithCIImage:[CIImage imageWithCVPixelBuffer:imageBuffer]];
        print("converted the frame to image")
       // self.image = UIImage(pixelBuffer: frame.imageBuffer)!
       // self.getImage?(1)
    }
    
    
    
//    private func frameToImage(frame: VideoFrame) -> UIImage?{
//
//        Log.echo(key: self.TAG, text: "frameToImage")
//        let frameRenderer = I420Frame(rtcFrame: frame, atTime: Date().timeIntervalSinceNow)
//        Log.echo(key: self.TAG, text: "got Frame Renderer")
//        return frameRenderer?.getUIImage()
//    }
}


