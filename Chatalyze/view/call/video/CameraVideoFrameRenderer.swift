//
//  File.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 10/09/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo
import Foundation

class CameraVideoFrameRenderer : VideoFrameRenderer {

  
    private let TAG = "CameraVideoFrameRenderer"

    override func frameToImage(frame: VideoFrame) -> UIImage?{
                
        let ciImage = CIImage.init(cvImageBuffer: frame.imageBuffer, options: nil)
        let context = CIContext(options: nil)
        Log.echo(key: TAG, text: "width -> \(frame.width), height-> \(frame.height) & orientation -> \(frame.orientation.rawValue)")
        
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return UIImage() }
        let image = getImage(cgImage: cgImage, frame : frame)
        return image
    }
    
 
    
 
}


