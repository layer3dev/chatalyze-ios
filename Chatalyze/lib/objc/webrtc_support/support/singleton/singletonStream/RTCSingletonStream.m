

//
//  RTCSingletonStream.m
//  Chatalyze
//
//  Created by Sumant Handa on 23/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCSingletonStream.h"
#import "RTCSingletonStream+Internal.h"

@implementation RTCSingletonStream

static RTCSingletonStream *myInstance = nil;
static NSString * const kARDMediaStreamId = @"ARDAMS";
static NSString * const kARDAudioTrackId = @"ARDAMSa0";
static NSString * const kARDVideoTrackId = @"ARDAMSv0";
static NSString * const kARDVideoTrackKind = @"video";


+(RTCSingletonStream *)sharedInstance
{
    if(myInstance == nil)
    {
        myInstance = [[[self class] alloc] init];
        [myInstance initialization];
    }
    [myInstance initialization];
    return myInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void)initialization{
    self.factory = [[RTCSingletonFactory sharedInstance] factory];
    self.settingsModel = [[ARDSettingsModel alloc] init];
    
    NSLog(@"%@", self.settingsModel.availableVideoResolutions);
//    [self.settingsModel set]
}

-(RTCMediaStream *)getMediaCapturer:(void (^)(RTCCameraVideoCapturer *capturer))block{
    self.block = block;
    return [self createMediaSenders];
}


- (CallMediaTrack *)createMediaSenders {
    
    CallMediaTrack *mediaPackage = [CallMediaTrack new];
    RTCMediaConstraints *constraints = [self defaultMediaAudioConstraints];
    RTCAudioSource *source = [_factory audioSourceWithConstraints:constraints];
    RTCAudioTrack *track = [_factory audioTrackWithSource:source
                                                  trackId:kARDAudioTrackId];
    
    mediaPackage.audioTrack = track;
    _localVideoTrack = [self createLocalVideoTrack];
    if (_localVideoTrack) {
        mediaPackage.videoTrack = _localVideoTrack;
    }
    return mediaPackage;
}

- (RTCVideoTrack *)createLocalVideoTrack {
    if ([self.settingsModel currentAudioOnlySettingFromStore]) {
        return nil;
    }
    
    RTCVideoSource *source = [_factory videoSource];
    
#if !TARGET_IPHONE_SIMULATOR
    RTCCameraVideoCapturer *capturer = [[RTCCameraVideoCapturer alloc] initWithDelegate:source];
    self.block(capturer);
    
#endif
    
    return [_factory videoTrackWithSource:source trackId:kARDVideoTrackId];
}



- (RTCMediaConstraints *)defaultMediaAudioConstraints {
    NSDictionary *mandatoryConstraints = @{};
    RTCMediaConstraints *constraints =
    [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                          optionalConstraints:nil];
    return constraints;
}



@end
