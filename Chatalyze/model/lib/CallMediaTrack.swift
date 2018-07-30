//
//  CallMediaTrack.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

@objc class CallMediaTrack: NSObject {
    
    private var isAudioMuted = false
    private var isVideoMuted = false
    
    private var isMediaDisabled = false
    
    @objc var audioTrack : RTCAudioTrack?
    @objc var videoTrack : RTCVideoTrack?
    
    var muteAudio : Bool{
        get{
            return isAudioMuted
        }
        set{
            if(isAudioMuted == newValue){
                return
            }
            audioTrack?.isEnabled = !newValue
            isAudioMuted = newValue
        }
    }
    
    var muteVideo : Bool{
        get{
            return isVideoMuted
        }
        set{
            if(isVideoMuted == newValue){
                return
            }
            videoTrack?.isEnabled = !newValue
            isVideoMuted = newValue
        }
    }
    
    var isDisabled : Bool{
        get{
            return isMediaDisabled
        }
        set{
            if(isMediaDisabled == newValue){
                return
            }
            let disable = newValue
            isMediaDisabled = disable
            disable ? disableMedia() : enableMedia()
        }
    }
    
    private func enableMedia(){
        if(!muteAudio){
            audioTrack?.isEnabled = true
        }
        
        if(!muteVideo){
            videoTrack?.isEnabled = true
        }
    }
    
    private func disableMedia(){
        audioTrack?.isEnabled = false
        videoTrack?.isEnabled = false
    }
}
