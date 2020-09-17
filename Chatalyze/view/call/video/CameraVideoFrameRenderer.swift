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
                
        var ciImage = CIImage.init(cvImageBuffer: frame.imageBuffer, options: nil)
        if #available(iOS 11.0, *) {
//            ciImage = ciImage.oriented(CGImagePropertyOrientation.right)
        } else {
            // Fallback on earlier versions
        }
        let context = CIContext(options: nil)
        
        Log.echo(key: TAG, text: "width -> \(frame.width), height-> \(frame.height) & orientation -> \(frame.orientation.rawValue)")
        
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return UIImage() }
        let image = UIImage(cgImage: cgImage, scale : 1.0, orientation: getOrientation(frame: frame))
        return image
    }
    
    private func getOrientation(frame : VideoFrame) -> UIImage.Orientation{
        let orientation = frame.orientation
        Log.echo(key: TAG, text: "orientation -> \(orientation)")
        
        switch orientation {
        case VideoOrientation.up:
            return UIImage.Orientation.up
        case VideoOrientation.down:
            return UIImage.Orientation.down
        case VideoOrientation.left:
            return UIImage.Orientation.right
        case VideoOrientation.right:
            return UIImage.Orientation.left
        default:
            return UIImage.Orientation.up
        
        }
    }
    
 
    
    
}


