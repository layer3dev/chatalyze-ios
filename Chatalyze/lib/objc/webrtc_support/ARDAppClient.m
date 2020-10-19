/*
 *  Copyright 2014 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDAppClient+Internal.h"
#import "SocketChannel.h"
#import "WebRTC/RTCAudioTrack.h"
#import "WebRTC/RTCCameraVideoCapturer.h"
#import "WebRTC/RTCConfiguration.h"
#import "WebRTC/RTCFileLogger.h"
#import "WebRTC/RTCFileVideoCapturer.h"
#import "WebRTC/RTCIceServer.h"
#import "WebRTC/RTCLogging.h"
#import "WebRTC/RTCMediaConstraints.h"
#import "WebRTC/RTCMediaStream.h"
#import "WebRTC/RTCPeerConnectionFactory.h"
#import "WebRTC/RTCRtpSender.h"
#import "WebRTC/RTCTracing.h"
#import "WebRTC/RTCVideoTrack.h"

#import "ARDAppEngineClient.h"
#import "ARDJoinResponse.h"
#import "ARDMessageResponse.h"
#import "ARDSettingsModel.h"
#import "ARDSignalingMessage.h"
#import "ARDTURNClient+Internal.h"
#import "ARDUtilities.h"
#import "ARDWebSocketChannel.h"
#import "RTCIceCandidate+JSON.h"
#import "RTCSessionDescription+JSON.h"

static NSString * const kARDIceServerRequestUrl = @"https://appr.tc/params";

static NSString * const kARDAppClientErrorDomain = @"Rumpur";
static NSInteger const kARDAppClientErrorCreateSDP = -3;
static NSInteger const kARDAppClientErrorSetSDP = -4;
static NSString * const kARDMediaStreamId = @"ARDAMS";
static NSString * const kARDAudioTrackId = @"ARDAMSa0";
static NSString * const kARDVideoTrackId = @"ARDAMSv0";
static NSString * const kARDVideoTrackKind = @"video";

// TODO(tkchin): Add these as UI options.
static int const kKbpsMultiplier = 1000;



@implementation ARDAppClient {
  RTCFileLogger *_fileLogger;
  ARDSettingsModel *_settings;
  RTCVideoTrack *_localVideoTrack;
}


@synthesize shouldGetStats = _shouldGetStats;
@synthesize state = _state;
@synthesize delegate = _delegate;
@synthesize channel = _channel;
@synthesize socketChannel = _socketChannel;
@synthesize loopbackChannel = _loopbackChannel;
@synthesize turnClient = _turnClient;
@synthesize peerConnection = _peerConnection;
@synthesize factory = _factory;
@synthesize isTurnComplete = _isTurnComplete;
@synthesize hasReceivedSdp  = _hasReceivedSdp;
@synthesize eventId = _eventId;
@synthesize clientId = _clientId;
@synthesize isInitiator = _isInitiator;
@synthesize iceServers = _iceServers;
@synthesize webSocketURL = _websocketURL;
@synthesize webSocketRestURL = _websocketRestURL;
@synthesize isSpeakerEnabled = _isSpeakerEnabled;
@synthesize defaultPeerConnectionConstraints =
    _defaultPeerConnectionConstraints;
@synthesize isLoopback = _isLoopback;


+(void)releaseLocalStream{
    [RTCSingletonFactory releaseShared];
}


- (instancetype)init {
  return [self initWithDelegate:nil];
}

-(instancetype)initWithUserId:(NSString *)userId andReceiverId:(NSString *)receiverId andEventId:(NSString *)eventId andDelegate:(id<ARDAppClientDelegate>)delegate andLocalStream:(CallMediaTrack *)localMediaPackage
{
    
    if (self = [super init]) {
        _delegate = delegate;
        NSURL *turnRequestURL = [NSURL URLWithString:kARDIceServerRequestUrl];
        self.userId = userId;
        self.receiverId = receiverId;
        self.eventId = eventId;
        self.localMediaPackage = localMediaPackage;
        [self configure];
        [self initialize];
    }
    return self;
}


- (instancetype)initWithDelegate:(id<ARDAppClientDelegate>)delegate {
  if (self = [super init]) {
    _delegate = delegate;
    NSURL *turnRequestURL = [NSURL URLWithString:kARDIceServerRequestUrl];
    [self configure];
    [self initialize];
  }
  return self;
}

-(Boolean)isSignallingCompleted{
    return [_socketChannel isSignallingCompleted];
}

-(RTCIceConnectionState)getIceConnectionState{
    return _peerConnection.iceConnectionState;
}


- (void)configure {
    _iceServers = [NSMutableArray array];
    _socketChannel = [[SocketChannel alloc] initWithEventId : self.eventId];
    _socketChannel.listener = self;
    
     [Log echoWithKey:@"user" text:[NSString stringWithFormat:@"userId --->  %@", self.userId]];
    [Log echoWithKey:@"user" text:[NSString stringWithFormat:@"receiverId --->  %@", self.receiverId]];
    _socketChannel.userId = self.userId;
    _socketChannel.receiverId = self.receiverId;
    _socketChannel.eventId = self.eventId;
}

- (void)dealloc {
  [self disconnect];
}


- (void)setState:(ARDAppClientState)state {
  if (_state == state) {
    return;
  }
  _state = state;
  [_delegate appClient:self didChangeState:_state];
}

//start
- (void)initialize{
    
  _factory = [[RTCSingletonFactory sharedInstance] factory];

}

- (void)disconnect {
 
  if (_channel) {
    if (_channel.state == kARDSignalingChannelStateRegistered) {
      // Tell the other client we're hanging up.
      ARDByeMessage *byeMessage = [[ARDByeMessage alloc] init];
      [_channel sendMessage:byeMessage];
    }
    // Disconnect from collider.
    _channel = nil;
  }
    _clientId = nil;
    _eventId = nil;
    _isInitiator = NO;
    _hasReceivedSdp = NO;
    _localVideoTrack = nil;
    [_socketChannel disconnect];
    _socketChannel = nil;

    [_peerConnection close];
    
    _peerConnection = nil;

}

#pragma mark - ARDSignalingChannelDelegate

- (void)channel:(id<ARDSignalingChannel>)channel
    didReceiveMessage:(ARDSignalingMessage *)message {
  switch (message.type) {
    case kARDSignalingMessageTypeOffer:
    case kARDSignalingMessageTypeAnswer:
      // Offers and answers must be processed before any other message, so we
      // place them at the front of the queue.
      
      break;
    case kARDSignalingMessageTypeCandidate:
    case kARDSignalingMessageTypeCandidateRemoval:
      break;
    case kARDSignalingMessageTypeBye:
      // Disconnects can be processed immediately.
      [self processSignalingMessage:message];
      return;
  }

}

- (void)channel:(id<ARDSignalingChannel>)channel
    didChangeState:(ARDSignalingChannelState)state {
  switch (state) {
    case kARDSignalingChannelStateOpen:
      break;
    case kARDSignalingChannelStateRegistered:
      break;
    case kARDSignalingChannelStateClosed:
    case kARDSignalingChannelStateError:
      // TODO(tkchin): reconnection scenarios. Right now we just disconnect
      // completely if the websocket connection fails.
      [self disconnect];
      break;
  }
}

#pragma mark - RTCPeerConnectionDelegate
// Callbacks for this delegate occur on non-main thread and need to be
// dispatched back to main queue as needed.

- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didChangeSignalingState:(RTCSignalingState)stateChanged {
  RTCLog(@"Signaling state changed: %ld", (long)stateChanged);
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
          didAddStream:(RTCMediaStream *)stream {
    RTCLog(@"Stream with %lu video tracks and %lu audio tracks was added.",
           (unsigned long)stream.videoTracks.count,
           (unsigned long)stream.audioTracks.count);
}

/*- (void)peerConnection:(RTCPeerConnection *)peerConnection
          didAddStream:(RTCMediaStream *)stream {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"Received %lu video tracks and %lu audio tracks",
        (unsigned long)stream.videoTracks.count,
        (unsigned long)stream.audioTracks.count);
      
      RTCAudioTrack *audioTrack = stream.audioTracks[0];
      audioTrack.source.volume = 0.1;
//      audioTrack.isEnabled = false;
//      [stream removeAudioTrack:stream.audioTracks[0]];
      
    if (stream.videoTracks.count) {
      RTCVideoTrack *videoTrack = stream.videoTracks[0];
      [_delegate appClient:self didReceiveRemoteVideoTrack:videoTrack];
    }
  });
}*/

- (void)peerConnection:(RTCPeerConnection *)peerConnection
didStartReceivingOnTransceiver:(RTCRtpTransceiver *)transceiver {
    RTCMediaStreamTrack *track = transceiver.receiver.track;
    RTCLog(@"Now receiving %@ on track %@.", track.kind, track.trackId);
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
       didRemoveStream:(RTCMediaStream *)stream {
  RTCLog(@"Stream was removed.");
}

- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection {
  RTCLog(@"WARNING: Renegotiation needed but unimplemented.");
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didChangeIceConnectionState:(RTCIceConnectionState)newState {
    
  RTCLog(@"ICE state changed: %ld", (long)newState);
  dispatch_async(dispatch_get_main_queue(), ^{
    [_delegate appClient:self didChangeConnectionState:newState];
  });
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didChangeIceGatheringState:(RTCIceGatheringState)newState {
  RTCLog(@"ICE gathering state changed: %ld", (long)newState);
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didGenerateIceCandidate:(RTCIceCandidate *)candidate {
    
  dispatch_async(dispatch_get_main_queue(), ^{
//    ARDICECandidateMessage *message =
//        [[ARDICECandidateMessage alloc] initWithCandidate:candidate];
//    [self sendSignalingMessage:message];
      [self emitIceCandidate:candidate];
  });
}


-(void)emitIceCandidate:(RTCIceCandidate *)candidate{
    [Log echoWithKey:@"candidate" text:[NSString stringWithFormat:@"dict - > %@", [candidate JSONDictionary]]];
    [_socketChannel emitCandidate:candidate];
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates {
  dispatch_async(dispatch_get_main_queue(), ^{
    ARDICECandidateRemovalMessage *message =
        [[ARDICECandidateRemovalMessage alloc]
            initWithRemovedCandidates:candidates];
    [self sendSignalingMessage:message];
  });
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didOpenDataChannel:(RTCDataChannel *)dataChannel {
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeConnectionState:(RTCPeerConnectionState)newState {
    
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
        didAddReceiver:(RTCRtpReceiver *)rtpReceiver
               streams:(NSArray<RTCMediaStream *> *)mediaStreams{
    
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
     didRemoveReceiver:(RTCRtpReceiver *)rtpReceiver{
    
}

#pragma mark - RTCSessionDescriptionDelegate
// Callbacks for this delegate occur on non-main thread and need to be
// dispatched back to main queue as needed.



- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp andType:(ARDSignalingMessageType)type error:(NSError *)error {
    
  dispatch_async(dispatch_get_main_queue(), ^{
    
      [Log echoWithKey:@"peer" text:@"parent didCreateSessionDescription"];
    if (error) {
      RTCLogError(@"Failed to create session description. Error: %@", error);
      [self disconnect];
      NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"Failed to create session description.",
      };
      NSError *sdpError =
          [[NSError alloc] initWithDomain:kARDAppClientErrorDomain
                                     code:kARDAppClientErrorCreateSDP
                                 userInfo:userInfo];
      [_delegate appClient:self didError:sdpError];
      return;
    }
    __weak ARDAppClient *weakSelf = self;
      
    [_peerConnection setLocalDescription:sdp
                       completionHandler:^(NSError *error) {
                         ARDAppClient *strongSelf = weakSelf;
                         [strongSelf peerConnection:strongSelf.peerConnection
                             didSetSessionDescriptionWithError:error];
                       }];
    ARDSessionDescriptionMessage *message =
        [[ARDSessionDescriptionMessage alloc] initWithDescription:sdp];
      
      if(type == kARDSignalingMessageTypeOffer){
          [_socketChannel emitOffer:sdp];
      }else{
          [_socketChannel emitAnswer:sdp];
      }
      
      
    
      
      
//    [self sendSignalingMessage:message];
    [self setMaxBitrateForPeerConnectionVideoSender];
  });
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didSetSessionDescriptionWithError:(NSError *)error {
    
    [Log echoWithKey:@"sdp" text:@"didSetSessionDescriptionWithError -- !!"];
  dispatch_async(dispatch_get_main_queue(), ^{
    if (error) {
        [Log echoWithKey:@"sdp" text:@"didSetSession [error] -- !!"];
      RTCLogError(@"Failed to set session description. Error: %@", error);
      [self disconnect];
      NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"Failed to set session description.",
      };
      NSError *sdpError =
          [[NSError alloc] initWithDomain:kARDAppClientErrorDomain
                                     code:kARDAppClientErrorSetSDP
                                 userInfo:userInfo];
      [_delegate appClient:self didError:sdpError];
      return;
    }
      [Log echoWithKey:@"sdp" text:@"didSetSessionDescription check if not initiat -- !!"];
    // If we're answering and we've just set the remote offer we need to create
    // an answer and set the local description.
    if (!_isInitiator && !_peerConnection.localDescription) {
      RTCMediaConstraints *constraints = [self defaultAnswerConstraints];
        
        [Log echoWithKey:@"sdp" text:@"setAnswer -- !!"];
        
      __weak ARDAppClient *weakSelf = self;
      [_peerConnection answerForConstraints:constraints
                          completionHandler:^(RTCSessionDescription *sdp,
                                              NSError *error) {
                              
                              
        [Log echoWithKey:@"sdp" text:@"Answer created-- !!"];
        ARDAppClient *strongSelf = weakSelf;
        [strongSelf peerConnection:strongSelf.peerConnection
            didCreateSessionDescription:sdp andType:kARDSignalingMessageTypeAnswer
                                  error:error];
      }];
    }
  });
}

#pragma mark - Private


-(void)createPeerConnection{
    // Create peer connection.
    
    RTCMediaConstraints *constraints = [self defaultPeerConnectionConstraints];
    RTCConfiguration *config = [[RTCConfiguration alloc] init];
    _iceServers = [[self defaultSTUNServer] mutableCopy];
    config.iceServers = _iceServers;
    config.sdpSemantics = RTCSdpSemanticsUnifiedPlan;
    _peerConnection = [_factory peerConnectionWithConfiguration:config
                                                    constraints:constraints
                                                       delegate:self];
    
    
//    [_peerConnection addTrack:self.localMediaPackage.audioTrack streamIds:@[ kARDMediaStreamId ]];
//    [_peerConnection addTrack:self.localMediaPackage.videoTrack streamIds:@[ kARDMediaStreamId ]];
    
    
    
    // We can set up rendering for the remote track right away since the transceiver already has an
    // RTCRtpReceiver with a track. The track will automatically get unmuted and produce frames
    // once RTP is received.
    RTCAudioTrack *receiverAudioTrack = (RTCAudioTrack *)([self audioTransceiver].receiver.track);
    RTCVideoTrack *receiverVideoTrack = (RTCVideoTrack *)([self videoTransceiver].receiver.track);
    
    CallMediaTrack *mediaPackage = [CallMediaTrack new];
//    mediaPackage.audioTrack = receiverAudioTrack;
//    mediaPackage.videoTrack = receiverVideoTrack;
    receiverAudioTrack.isEnabled = false;
    
    [_delegate appClient:self didReceiveRemoteMediaTrack:mediaPackage];
    
    
   
    
    // Create AV senders.
//    [self createMediaSenders];
    
    /*if(localStream && [localStream isLive]){
         [_peerConnection addStream:localStream];
         [_delegate appClient:self didReceiveLocalVideoTrack:[localStream.videoTracks firstObject]];
        
    }else{
        localStream = [self startLocalMedia];
        [_peerConnection addStream:localStream];
    }*/
    
}



- (void)initiateCall {
    _isInitiator = true;
    [self createPeerConnection];
    

    
    // Send offer.
    [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"initiateCall ARDAppClient"]];
    __weak ARDAppClient *weakSelf = self;
    [_peerConnection offerForConstraints:[self defaultOfferConstraints]
                       completionHandler:^(RTCSessionDescription *sdp,
                                           NSError *error) {
                           
                           [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"offerForConstraints -> %@", sdp.sdp]];
                           ARDAppClient *strongSelf = weakSelf;
                           [strongSelf peerConnection:strongSelf.peerConnection
                          didCreateSessionDescription:sdp andType:kARDSignalingMessageTypeOffer
                                                error:error];
                       }];

}

/*
-(void)processSignallingMessageWithAction:(NSString *)action andData:{
    
}*/


// Processes the given signaling message based on its type.
- (void)processSignalingMessage:(ARDSignalingMessage *)message {
  NSParameterAssert(_peerConnection ||
      message.type == kARDSignalingMessageTypeBye);
  switch (message.type) {
    case kARDSignalingMessageTypeOffer:
    case kARDSignalingMessageTypeAnswer: {
      ARDSessionDescriptionMessage *sdpMessage =
          (ARDSessionDescriptionMessage *)message;
      RTCSessionDescription *description = sdpMessage.sessionDescription;
      __weak ARDAppClient *weakSelf = self;
      [_peerConnection setRemoteDescription:description
                          completionHandler:^(NSError *error) {
                            ARDAppClient *strongSelf = weakSelf;
                            [strongSelf peerConnection:strongSelf.peerConnection
                                didSetSessionDescriptionWithError:error];
                          }];
      break;
    }
    case kARDSignalingMessageTypeCandidate: {
      ARDICECandidateMessage *candidateMessage =
          (ARDICECandidateMessage *)message;
      [_peerConnection addIceCandidate:candidateMessage.candidate];
      break;
    }
   
    case kARDSignalingMessageTypeBye:
      // Other client disconnected.
      // TODO(tkchin): support waiting in room for next client. For now just
      // disconnect.
      [self disconnect];
      break;
  }
}

// Sends a signaling message to the other client. The caller will send messages
// through the room server, whereas the callee will send messages over the
// signaling channel.
- (void)sendSignalingMessage:(ARDSignalingMessage *)message {
    [_channel sendMessage:message];
}







- (void)setMaxBitrateForPeerConnectionVideoSender {
    for (RTCRtpSender *sender in _peerConnection.senders) {
        if (sender.track != nil) {
            if ([sender.track.kind isEqualToString:kARDVideoTrackKind]) {
                [self setMaxBitrate:[_settings currentMaxBitrateSettingFromStore] forVideoSender:sender];
            }
        }
    }
}

- (void)setMaxBitrate:(NSNumber *)maxBitrate forVideoSender:(RTCRtpSender *)sender {
    if (maxBitrate.intValue <= 0) {
        return;
    }
    
    RTCRtpParameters *parametersToModify = sender.parameters;
    for (RTCRtpEncodingParameters *encoding in parametersToModify.encodings) {
        encoding.maxBitrateBps = @(maxBitrate.intValue * kKbpsMultiplier);
    }
    [sender setParameters:parametersToModify];
}


- (RTCRtpTransceiver *)videoTransceiver {
    for (RTCRtpTransceiver *transceiver in _peerConnection.transceivers) {
        if (transceiver.mediaType == RTCRtpMediaTypeVideo) {
            return transceiver;
        }
    }
    return nil;
}

- (RTCRtpTransceiver *)audioTransceiver {
    for (RTCRtpTransceiver *transceiver in _peerConnection.transceivers) {
        if (transceiver.mediaType == RTCRtpMediaTypeAudio) {
            return transceiver;
        }
    }
    return nil;
}


- (CallMediaTrack *)createMediaSenders {
    
    CallMediaTrack *mediaPackage = [CallMediaTrack new];

    dispatch_async(dispatch_get_main_queue(), ^{
       
        RTCMediaConstraints *constraints = [self defaultMediaAudioConstraints];
        RTCAudioSource *source = [self->_factory audioSourceWithConstraints:constraints];
        RTCAudioTrack *track = [self->_factory audioTrackWithSource:source
                                                      trackId:kARDAudioTrackId];
        
//        mediaPackage.audioTrack = track;
        
        [self->_peerConnection addTrack:track streamIds:@[ kARDMediaStreamId ]];
        self->_localVideoTrack = [self createLocalVideoTrack];
        if (self->_localVideoTrack) {
//            mediaPackage.videoTrack = self->_localVideoTrack;
        }
    });
    
    return mediaPackage;
}

- (RTCVideoTrack *)createLocalVideoTrack {
    if ([_settings currentAudioOnlySettingFromStore]) {
        return nil;
    }
    
    RTCVideoSource *source = [_factory videoSource];
    
#if !TARGET_IPHONE_SIMULATOR
    RTCCameraVideoCapturer *capturer = [[RTCCameraVideoCapturer alloc] initWithDelegate:source];
    [_delegate appClient:self didCreateLocalCapturer:capturer];

#endif
    
    return [_factory videoTrackWithSource:source trackId:kARDVideoTrackId];
}

#pragma mark - Collider methods


#pragma mark - Defaults

- (RTCMediaConstraints *)defaultMediaAudioConstraints {
    NSDictionary *mandatoryConstraints = @{};
    RTCMediaConstraints *constraints =
    [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                          optionalConstraints:nil];
    return constraints;
}



- (RTCMediaConstraints *)defaultAnswerConstraints {
  return [self defaultOfferConstraints];
}


- (NSArray<RTCIceServer *> *)defaultSTUNServer {
    
    return TurnServerInfo.sharedInstance.infos;
    
    /*return [[RTCIceServer alloc] initWithURLStrings:@[@"stun:stun.l.google.com:19302",
                                                      @"stun:stun1.l.google.com:19302",
                                                      @"stun:stun2.l.google.com:19302",
                                                      @"stun:stun3.l.google.com:19302",
                                                      @"stun:stun4.l.google.com:19302"]
                                           username:@""
                                         credential:@""];*/
}


- (RTCMediaConstraints *)defaultOfferConstraints {
    NSDictionary *mandatoryConstraints = @{
                                           @"OfferToReceiveAudio" : @"true",
                                           @"OfferToReceiveVideo" : @"true"
                                           };
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:mandatoryConstraints
     optionalConstraints:nil];
    return constraints;
}


- (RTCMediaConstraints *)defaultPeerConnectionConstraints {
  if (_defaultPeerConnectionConstraints) {
    return _defaultPeerConnectionConstraints;
  }
  NSDictionary *optionalConstraints = @{ @"DtlsSrtpKeyAgreement" : @"true" };
  RTCMediaConstraints* constraints =
      [[RTCMediaConstraints alloc]
          initWithMandatoryConstraints:nil
                   optionalConstraints:optionalConstraints];
  return constraints;
}



#pragma mark - SocketChannelListenerProtocol
-(void)processCandidate:(RTCIceCandidate *)info{
    [_peerConnection addIceCandidate:info];
}



-(void)processRawSDPOffer:(NSDictionary *)data{
    NSDictionary *sdp = data;
    
     [Log echoWithKey:@"sdp" text:@"processRawSDPOffer -- !!"];
    RTCSessionDescription *description =
    [RTCSessionDescription descriptionFromJSONDictionary:sdp];
    [self processSDPOffer:description];
}

-(void)processSDPOffer:(RTCSessionDescription *)info{
    [self createPeerConnection];
    [Log echoWithKey:@"sdp" text:@"processSDPOffer -- !!"];
    
    [_peerConnection setRemoteDescription:info
                        completionHandler:^(NSError *error) {
                            [self peerConnection:self.peerConnection
                     didSetSessionDescriptionWithError:error];
                        }];
}

-(void)processSDPAnswer:(RTCSessionDescription *)info{
    
    [_peerConnection setRemoteDescription:info
                        completionHandler:^(NSError *error) {
                            ARDAppClient *strongSelf = self;
                            [strongSelf peerConnection:strongSelf.peerConnection
                     didSetSessionDescriptionWithError:error];
                        }];
}




#pragma mark - Audio mute/unmute
- (void)muteAudioIn {
    NSLog(@"audio muted");
    RTCAudioTrack *track = (RTCAudioTrack *)([self audioTransceiver].sender.track);
    track.isEnabled = false;
    self.isAudioMuted = true;
}
- (void)unmuteAudioIn {
    NSLog(@"audio unmuted");
    RTCAudioTrack *track = (RTCAudioTrack *)([self audioTransceiver].sender.track);
    track.isEnabled = true;
//    if (_isSpeakerEnabled) [self enableSpeaker];
    self.isAudioMuted = false;
}

#pragma mark - Video mute/unmute
- (void)muteVideoIn {
    NSLog(@"video muted");
    RTCAudioTrack *track = (RTCAudioTrack *)([self videoTransceiver].sender.track);
    track.isEnabled = false;
    
    self.isVideoMuted = true;
}
- (void)unmuteVideoIn {
    NSLog(@"video unmuted");
    RTCAudioTrack *track = (RTCAudioTrack *)([self videoTransceiver].sender.track);
    track.isEnabled = true;
    
    self.isVideoMuted = false;
}


-(BOOL)isIdeal{
    return false;
}
-(BOOL)isConnected{
    return false;
}
-(BOOL)isProcessing{
    return false;
}


- (NSString *)localStreamLabel {
    return @"ARDAMS";
}

- (NSString *)audioTrackId {
    return [[self localStreamLabel] stringByAppendingString:@"a0"];
}

- (NSString *)videoTrackId {
    return [[self localStreamLabel] stringByAppendingString:@"v0"];
}

- (void)setupLocalAudio :(RTCMediaStream *)localStream{
    RTCAudioTrack *audioTrack = [self.factory audioTrackWithTrackId:[self audioTrackId]];
    if (localStream && audioTrack) {
        [localStream addAudioTrack:audioTrack];
    }
}


- (RTCMediaConstraints *)videoConstraints
{
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:nil];
    return constraints;
}

#pragma mark - swap camera


#pragma mark - enable/disable speaker

- (void)enableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    _isSpeakerEnabled = YES;
}

- (void)disableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    _isSpeakerEnabled = NO;
}


@end
