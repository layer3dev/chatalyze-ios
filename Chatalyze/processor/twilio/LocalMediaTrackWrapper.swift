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
    
    var trackTag : String = ""
    let isPreview : Bool
    var isLocked = false
    let videoTrack : LocalVideoTrack?
    var audioTrack : LocalAudioTrack?
    
    private var isVideoMuted = false
    private var isAudioMuted = false
    
    private var TAG : String{
        get{
            return "LocalMediaTrackWrapper \(trackTag)"
        }
    }

    
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
        
        mute()
        
    }
    
    convenience init(source : LocalCameraSource){
        self.init(isPreview: false, source : source)
    }
    
    func muteVideo(){
        Log.echo(key: TAG, text: "muteVideo")
        isVideoMuted = true
        videoTrack?.isEnabled = false
    }
    
    
    
    func muteAudio(){
        Log.echo(key: TAG, text: "muteAudio")
        isAudioMuted = true
        audioTrack?.isEnabled = false
    }
    
    func unmuteVideo(){
        isVideoMuted = false
        Log.echo(key: TAG, text: "unmuteVideo isLocked -> \(isLocked)")
        if(!isLocked){
            return
        }
        videoTrack?.isEnabled = true
    }
    
    func unmuteAudio(){
        isAudioMuted = false
        Log.echo(key: TAG, text: "unmuteAudio isLocked -> \(isLocked)")
        if(!isLocked){
            return
        }
        audioTrack?.isEnabled = true
    }
    
    
    func mute(){
        Log.echo(key: TAG, text: "muteAll")
        videoTrack?.isEnabled = false
        audioTrack?.isEnabled = false
    }
    
    
    func unmute(){
        Log.echo(key: TAG, text: "unmuteAll -> \(isLocked) isAudioMuted-> \(isAudioMuted) isVideoMuted-> \(isVideoMuted)")
        if(!isLocked){
            return
        }
    
        
        Log.echo(key: TAG, text: "executed")
        
        if(!isAudioMuted){
            audioTrack?.isEnabled = true
        }
        
        
        if(!isVideoMuted){
            videoTrack?.isEnabled = true
        }
    
    }
    
    func acquireLock(){
        Log.echo(key: TAG, text: "acquireLock")
        isLocked = true
        mute()
    }
    
    func releaseLock(){
        Log.echo(key: TAG, text: "releaseLock")
        isLocked = false
        mute()
    }
    
    
}
