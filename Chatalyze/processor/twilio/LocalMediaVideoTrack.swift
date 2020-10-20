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
        previewTrack.muteVideo()
        trackOne?.muteVideo()
        trackTwo?.muteVideo()
    }
    
    func unmuteVideo(){
        previewTrack.unmuteVideo()
        trackOne?.unmuteVideo()
        trackTwo?.unmuteVideo()
    }
    
    func muteAudio(){
        previewTrack.muteAudio()
        trackOne?.muteAudio()
        trackTwo?.muteAudio()
    }
    
    func unmuteAudio(){
        previewTrack.unmuteAudio()
        trackOne?.unmuteAudio()
        trackTwo?.unmuteAudio()
    }
    
    func start(){
        source.startCapturer()
    }
    
    func stop(){
        source.stop()
    }
    
}
