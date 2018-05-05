//
//  CallMediaTrack.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

@objc class CallMediaTrack: NSObject {
    @objc var audioTrack : RTCAudioTrack?
    @objc var videoTrack : RTCVideoTrack?
}
