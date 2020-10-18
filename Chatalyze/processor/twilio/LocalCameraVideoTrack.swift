//
//  LocalCameraVideoTrack.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 18/10/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

class LocalCameraVideoTrack {
    
    private let source : LocalCameraSource
    let previewTrack : LocalVideoTrackWrapper
    var trackOne : LocalVideoTrackWrapper?
    var trackTwo : LocalVideoTrackWrapper?
    
    private let doesRequireMultipleTracks : Bool
    
    
    
    init(doesRequireMultipleTracks : Bool) {
        self.doesRequireMultipleTracks = doesRequireMultipleTracks
        source = LocalCameraSource()
        previewTrack = LocalVideoTrackWrapper(isPreview : true, source: source)

        if(!doesRequireMultipleTracks){
            return
        }
        
        trackOne = LocalVideoTrackWrapper(source: source)
        trackTwo = LocalVideoTrackWrapper(source: source)
        initialization()
    }
    
    
    
    private func  initialization(){
        
    }
    
    var bufferTrack : LocalVideoTrack?{
        get{
            if(!doesRequireMultipleTracks){
                return previewTrack.track
            }
            
            if(!(trackOne?.isLocked ?? false)){
                return trackOne?.track
            }
            
            if(!(trackTwo?.isLocked ?? false)){
                return trackTwo?.track
            }
            
            return nil
        }
    }
    
    func mute(){
        previewTrack.track?.isEnabled = false
        trackOne?.track?.isEnabled = false
        trackOne?.track?.isEnabled = false
    }
    
    func unmute(){
        previewTrack.track?.isEnabled = true
        trackOne?.track?.isEnabled = true
        trackOne?.track?.isEnabled = true
    }
    
    func start(){
        source.startCapturer()
    }
    
    func stop(){
        source.stop()
    }
    
}
