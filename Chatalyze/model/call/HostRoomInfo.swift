//
//  HostRoomInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 11/11/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import TwilioVideo

class HostRoomInfo: NSObject {
    
    var remoteParticipant:RemoteParticipant?
    var remoteVideoTrack:RemoteVideoTrack?
    var remoteAudioTrack:RemoteAudioTrack?
    var isRendered = false
}
