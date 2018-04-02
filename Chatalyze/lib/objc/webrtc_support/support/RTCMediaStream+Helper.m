//
//  RTCMediaStream+Helper.m
//  Chatalyze
//
//  Created by Sumant Handa on 02/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCMediaStream+Helper.h"

@implementation RTCMediaStream (Helper)

-(BOOL)isLive{
    RTCVideoTrack *track = [self.videoTracks firstObject];
    if(track && track.readyState == RTCMediaStreamTrackStateLive){
        return true;
    }
    return false;
}

@end
