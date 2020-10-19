//
//  CallMediaTrack.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import TwilioVideo

@objc class CallMediaTrack: NSObject {
    
    internal var isAudioMuted = false
    internal var isVideoMuted = false
    
    internal var isMediaDisabled = false
    
    var mediaTrack : LocalMediaVideoTrack?
    
    
    
    internal var muteAudio : Bool{
        get{
            return isAudioMuted
        }
        set{
            if(isAudioMuted == newValue){
                return
            }
            mediaTrack?.muteAudio()
            isAudioMuted = newValue
        }
    }
    
    internal var muteVideo : Bool{
        get{
            return isVideoMuted
        }
        set{
            if(isVideoMuted == newValue){
                return
            }
            mediaTrack?.muteVideo()
            isVideoMuted = newValue
        }
    }
    
    internal var isDisabled : Bool{
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
    
    internal func enableMedia(){
        
        mediaTrack?.unmuteAudio()
        mediaTrack?.unmuteVideo()
        
        //Client wanted to activate both video and audio, when host recovers from hangup state, even if video/audio would had been muted earlier
        /*if(!muteAudio){
            audioTrack?.isEnabled = true
        }
        
        if(!muteVideo){
            videoTrack?.isEnabled = true
        }*/
    }
    
    internal func disableMedia(){
        mediaTrack?.muteAudio()
        mediaTrack?.muteVideo()
    }
}

