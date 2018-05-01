//
//  RTCSingletonFactory.m
//  Chatalyze
//
//  Created by Sumant Handa on 23/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCSingletonFactory.h"

@implementation RTCSingletonFactory{
    
}

static RTCSingletonFactory *myInstance = nil;

+(RTCSingletonFactory *)sharedInstance
{
    if(myInstance == nil)
    {
        myInstance = [[[self class] alloc] init];
        [myInstance initialization];
    }
    
    return myInstance;
}

+(void)releaseShared{
    myInstance = nil;
}

-(void)initialization{
    ARDSettingsModel *settings = [[ARDSettingsModel alloc] init];
    RTCDefaultVideoDecoderFactory *decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
    RTCDefaultVideoEncoderFactory *encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
    encoderFactory.preferredCodec = [settings currentVideoCodecSettingFromStore];
    
    self.factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:encoderFactory
                                                         decoderFactory:decoderFactory];
}
@end
