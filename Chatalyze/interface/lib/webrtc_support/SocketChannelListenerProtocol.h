//
//  SocketChannelListenerProtocol.h
//  Rumpur
//
//  Created by Sumant Handa on 15/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARDUtilities.h"

@protocol SocketChannelListenerProtocol <NSObject>

-(void)processCandidate:(RTCIceCandidate *)info;
-(void)processSDPOffer:(RTCSessionDescription *)info;
-(void)processSDPAnswer:(RTCSessionDescription *)info;

@end
