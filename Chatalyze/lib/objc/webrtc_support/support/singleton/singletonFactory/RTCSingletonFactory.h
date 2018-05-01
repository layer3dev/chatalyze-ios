//
//  RTCSingletonFactory.h
//  Chatalyze
//
//  Created by Sumant Handa on 23/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTCSingletonFactory : NSObject

+(RTCSingletonFactory *)sharedInstance;
+(void)releaseShared;
@property (strong, nonatomic) RTCPeerConnectionFactory *factory;
@property (strong, nonatomic) RTCMediaStream *localStream;

@end
