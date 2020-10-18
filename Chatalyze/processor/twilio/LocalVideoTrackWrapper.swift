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

class LocalVideoTrackWrapper{
    
    let isPreview : Bool
    var isLocked = false
    let track : LocalVideoTrack?
    
    init(isPreview : Bool, source : LocalCameraSource) {
        self.isPreview = isPreview
        track = LocalVideoTrack(source: source)
    }
    
    convenience init(source : LocalCameraSource){
        self.init(isPreview: false, source : source)
    }
    
    
    
}
