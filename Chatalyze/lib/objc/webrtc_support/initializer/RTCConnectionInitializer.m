//
//  RTCConnectionInitializer.m
//  Chatalyze
//
//  Created by Sumant Handa on 27/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCConnectionInitializer.h"
//WebRTC Files
#import "WebRTC/RTCFieldTrials.h"
#import "WebRTC/RTCLogging.h"
#import "WebRTC/RTCSSLAdapter.h"
#import "WebRTC/RTCTracing.h"


@interface RTCConnectionInitializer ()
@property (strong, nonatomic)AudioManager *audioManager;
@end


@implementation RTCConnectionInitializer




- (instancetype)init {
    if (self = [super init]) {
        // Initialize self
        [self initialize];
        
    }
    return self;
}

-(void)initialize{
    [self initializeWebRTC];
}

-(void)initializeWebRTC{
    
    NSDictionary *fieldTrials = @{
                                  kRTCFieldTrialH264HighProfileKey: kRTCFieldTrialEnabledValue,
                                  };
    RTCInitFieldTrialDictionary(fieldTrials);
    RTCInitializeSSL();
    RTCSetupInternalTracer();
    
    self.audioManager = [AudioManager new];
    if(DevFlag.debug){
        
        //RTCSetMinDebugLogLevel(RTCLoggingSeverityInfo);
    }
}

@end
