/*
 *  Copyright 2014 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDAppClient.h"
#import "WebRTC/RTCPeerConnection.h"
#import "ARDRoomServerClient.h"
#import "ARDSignalingChannel.h"
#import "ARDTURNClient.h"
#import "SocketChannel.h"
#import "RTCSingletonFactory.h"

@class RTCPeerConnectionFactory;
@class SocketChannel;

@interface ARDAppClient () <ARDSignalingChannelDelegate,
  RTCPeerConnectionDelegate, SocketChannelListenerProtocol>

// All properties should only be mutated from the main queue.
@property(nonatomic, strong) id<ARDRoomServerClient> roomServerClient;
@property(nonatomic, strong) id<ARDSignalingChannel> channel;
@property(nonatomic, strong) SocketChannel *socketChannel;

@property(nonatomic, strong) id<ARDSignalingChannel> loopbackChannel;
@property(nonatomic, strong) id<ARDTURNClient> turnClient;

@property(nonatomic, strong) RTCPeerConnection *peerConnection;
@property(nonatomic, strong) RTCPeerConnectionFactory *factory;
@property(nonatomic, strong) NSMutableArray *messageQueue;

@property(nonatomic, assign) BOOL isTurnComplete;
@property(nonatomic, assign) BOOL hasReceivedSdp;
@property(nonatomic, readonly) BOOL hasJoinedRoomServerRoom;

@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) NSString *clientId;
@property(nonatomic, assign) BOOL isInitiator;
@property(nonatomic, strong) NSMutableArray *iceServers;
@property(nonatomic, strong) NSURL *webSocketURL;
@property(nonatomic, strong) NSURL *webSocketRestURL;
@property(nonatomic, readonly) BOOL isLoopback;

@property(nonatomic, assign) BOOL isAudioMuted;
@property(nonatomic, assign) BOOL isVideoMuted;

@property(nonatomic, strong) RTCAudioTrack *defaultAudioTrack;
@property(nonatomic, strong) RTCVideoTrack *defaultVideoTrack;
@property(nonatomic, assign) BOOL isSpeakerEnabled;
@property(nonatomic, assign) CallMediaTrack *localMediaPackage;


@property(nonatomic, strong)
    RTCMediaConstraints *defaultPeerConnectionConstraints;



- (instancetype)initWithRoomServerClient:(id<ARDRoomServerClient>)rsClient
                        signalingChannel:(id<ARDSignalingChannel>)channel
                              turnClient:(id<ARDTURNClient>)turnClient
                                delegate:(id<ARDAppClientDelegate>)delegate;


//Added Later
-(void)createPeerConnection;
- (RTCMediaConstraints *)defaultOfferConstraints;

-(void)emitIceCandidate:(RTCIceCandidate *)candidate;

-(void)processRawSDPOffer:(NSDictionary *)data;
- (void)disconnect;


- (void)muteAudioIn;
- (void)unmuteAudioIn;

- (void)muteVideoIn;
- (void)unmuteVideoIn;

-(BOOL)isIdeal;
-(BOOL)isConnected;
-(BOOL)isProcessing;

+(void)releaseLocalStream;


@end
