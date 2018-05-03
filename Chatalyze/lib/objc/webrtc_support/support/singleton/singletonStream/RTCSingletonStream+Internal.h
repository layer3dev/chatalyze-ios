//
//  RTCSingletonStream+Internal.h
//  Chatalyze
//
//  Created by Sumant Handa on 03/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import "RTCSingletonFactory.h"
#import "RTCSingletonStreamProtocol.h"

@class RTCSingletonFactory;

@interface RTCSingletonStream ()

@property (strong, nonatomic) RTCPeerConnectionFactory *factory;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) ARDSettingsModel *settingsModel;



@property (strong, nonatomic) void (^block)(RTCCameraVideoCapturer *capturer);


@end

