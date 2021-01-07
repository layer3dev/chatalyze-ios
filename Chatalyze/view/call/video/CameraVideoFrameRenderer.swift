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
        return convertRawFrameToImage(frame : frame)
    }
    
 
    
 
}


