//
//  SocketChannel.h
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketChannelListenerProtocol.h"

@interface SocketChannel : NSObject
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *receiverId;

@property(nonatomic, strong) NSString *eventId;

@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) id<SocketChannelListenerProtocol> listener;

-(void)emitOffer:(RTCSessionDescription *)sdp;
-(void)emitAnswer:(RTCSessionDescription *)sdp;
-(void)emitCandidate:(RTCIceCandidate *)candidate;
- (instancetype)initWithEventId : (NSString *)eventId ;

-(Boolean)isSignallingCompleted;

-(void)disconnect;

@end
