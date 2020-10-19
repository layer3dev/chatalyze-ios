//
//  LocalVideoTrackWrapper.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 18/10/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import TwilioVideo

class LocalMediaTrackWrapper{
    
    let isPreview : Bool
    var isLocked = false
    let videoTrack : LocalVideoTrack?
    var audioTrack : LocalAudioTrack?

    
    init(isPreview : Bool, source : LocalCameraSource) {
        self.isPreview = isPreview
        
        videoTrack = LocalVideoTrack(source: source)
        
        let options = AudioOptions(){(builder) in
            builder.isSoftwareAecEnabled = true
        }
        
        if(isPreview){
            return
        }
        
        audioTrack = LocalAudioTrack(options: options, enabled: true, name: "Microphone")
        
    }
    
    convenience init(source : LocalCameraSource){
        self.init(isPreview: false, source : source)
    }
    
    
    
    
    
}
