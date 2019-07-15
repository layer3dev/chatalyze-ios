//
//  AudioManager.m
//  Rumpur
//
//  Created by Sumant Handa on 20/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

-(void)initialization{
    [self configure];
}

-(void)configure{
    
    RTCAudioSessionConfiguration *webRTCConfig =
    [RTCAudioSessionConfiguration webRTCConfiguration];
    webRTCConfig.categoryOptions = webRTCConfig.categoryOptions |
    AVAudioSessionCategoryOptionDefaultToSpeaker;
    [RTCAudioSessionConfiguration setWebRTCConfiguration:webRTCConfig];
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    [session addDelegate:self];
    
    [self configureAudioSession];
    [self switchToSpeaker];
}

- (void)configureAudioSession {
    RTCAudioSessionConfiguration *configuration =
    [[RTCAudioSessionConfiguration alloc] init];
    configuration.category = AVAudioSessionCategoryAmbient;
    configuration.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
    configuration.mode = AVAudioSessionModeDefault;
    
    RTCAudioSession *session = [RTCAudioSession sharedInstance];
    NSError *errorSession = nil;
    
//    [session setActive:true error:&errorSession];
    [session lockForConfiguration];
    BOOL hasSucceeded = NO;
    NSError *error = nil;
    if (session.isActive) {
        hasSucceeded = [session setConfiguration:configuration error:&error];
    } else {
        hasSucceeded = [session setConfiguration:configuration
                                          active:YES
                                           error:&error];
    }
    if (!hasSucceeded) {
        RTCLogError(@"Error setting configuration: %@", error.localizedDescription);
    }
    [session unlockForConfiguration];
}

-(void)switchToSpeaker{
    AVAudioSessionPortOverride override = AVAudioSessionPortOverrideSpeaker;
    
    [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeAudioSession
                                 block:^{
                                     RTCAudioSession *session = [RTCAudioSession sharedInstance];
                                     [session lockForConfiguration];
                                     NSError *error = nil;
                                     if ([session overrideOutputAudioPort:override error:&error]) {
                                     } else {
                                         RTCLogError(@"Error overriding output port: %@",
                                                     error.localizedDescription);
                                     }
                                     [session unlockForConfiguration];
                                 }];
}


@end
