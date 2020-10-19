//
//  LocalCameraVideoTrack.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 18/10/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

class LocalMediaVideoTrack {

    private let source : LocalCameraSource
    let previewTrack : LocalMediaTrackWrapper
    var trackOne : LocalMediaTrackWrapper?
    var trackTwo : LocalMediaTrackWrapper?
    
    private let doesRequireMultipleTracks : Bool
    
    
    
    init(doesRequireMultipleTracks : Bool) {
        self.doesRequireMultipleTracks = doesRequireMultipleTracks
        source = LocalCameraSource()
        previewTrack = LocalMediaTrackWrapper(isPreview : true, source: source)

        if(!doesRequireMultipleTracks){
            return
        }
        
        trackOne = LocalMediaTrackWrapper(source: source)
        trackTwo = LocalMediaTrackWrapper(source: source)
        initialization()
    }
    
    
    
    private func  initialization(){
        
    }
    
    var bufferTrack : LocalMediaTrackWrapper?{
        get{
            if(!doesRequireMultipleTracks){
                return previewTrack
            }
            
            if(!(trackOne?.isLocked ?? false)){
                return trackOne
            }
            
            if(!(trackTwo?.isLocked ?? false)){
                return trackTwo
            }
            
            return nil
        }
    }
    
    func muteVideo(){
        previewTrack.videoTrack?.isEnabled = false
        trackOne?.videoTrack?.isEnabled = false
        trackOne?.videoTrack?.isEnabled = false
    }
    
    func unmuteVideo(){
        previewTrack.videoTrack?.isEnabled = true
        trackOne?.videoTrack?.isEnabled = true
        trackOne?.videoTrack?.isEnabled = true
    }
    
    func muteAudio(){
        previewTrack.audioTrack?.isEnabled = false
        trackOne?.audioTrack?.isEnabled = false
        trackOne?.audioTrack?.isEnabled = false
    }
    
    func unmuteAudio(){
        previewTrack.audioTrack?.isEnabled = true
        trackOne?.audioTrack?.isEnabled = true
        trackOne?.audioTrack?.isEnabled = true
    }
    
    func start(){
        source.startCapturer()
    }
    
    func stop(){
        source.stop()
    }
    
}
