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

#import "WebRTC/RTCAVFoundationVideoSource.h"
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
#import "WebRTC/RTCVideoCodecFactory.h"
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
static RTCMediaStream *localStream;


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
@synthesize roomId = _roomId;
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
    localStream = nil;
}

- (instancetype)init {
  return [self initWithDelegate:nil];
}

-(instancetype)initWithUserId:(NSString *)userId andReceiverId:(NSString *)receiverId andRoomId:(NSString *)roomId andDelegate:(id<ARDAppClientDelegate>)delegate
{
    
    if (self = [super init]) {
        _delegate = delegate;
        NSURL *turnRequestURL = [NSURL URLWithString:kARDIceServerRequestUrl];
        self.userId = userId;
        self.receiverId = receiverId;
        self.roomId = roomId;
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


- (void)configure {
    _iceServers = [NSMutableArray array];
    _socketChannel = [[SocketChannel alloc] init];
    _socketChannel.listener = self;
    
     [Log echoWithKey:@"user" text:[NSString stringWithFormat:@"userId --->  %@", self.userId]];
    [Log echoWithKey:@"user" text:[NSString stringWithFormat:@"receiverId --->  %@", self.receiverId]];
    _socketChannel.userId = self.userId;
    _socketChannel.receiverId = self.receiverId;
    _socketChannel.roomId = self.roomId;
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
    ARDSettingsModel *settings = [[ARDSettingsModel alloc] init];
  _settings = settings;
  RTCDefaultVideoDecoderFactory *decoderFactory = [[RTCDefaultVideoDecoderFactory alloc] init];
  RTCDefaultVideoEncoderFactory *encoderFactory = [[RTCDefaultVideoEncoderFactory alloc] init];
    encoderFactory.preferredCodec = [settings currentVideoCodecSettingFromStore];
    
  _factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:encoderFactory
                                                       decoderFactory:decoderFactory];

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
    _roomId = nil;
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
  dispatch_async(dispatch_get_main_queue(), ^{
    RTCLog(@"Received %lu video tracks and %lu audio tracks",
        (unsigned long)stream.videoTracks.count,
        (unsigned long)stream.audioTracks.count);
    if (stream.videoTracks.count) {
      RTCVideoTrack *videoTrack = stream.videoTracks[0];
      [_delegate appClient:self didReceiveRemoteVideoTrack:videoTrack];
    }
  });
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
    _iceServers = [NSMutableArray arrayWithObject:[self defaultSTUNServer]];
    config.iceServers = _iceServers;
    _peerConnection = [_factory peerConnectionWithConfiguration:config
                                                    constraints:constraints
                                                       delegate:self];
    // Create AV senders.
//    [self createMediaSenders];
    
    if(localStream && [localStream isLive]){
         [_peerConnection addStream:localStream];
         [_delegate appClient:self didReceiveLocalVideoTrack:[localStream.videoTracks firstObject]];
        
    }else{
        localStream = [self startLocalMedia];
        [_peerConnection addStream:localStream];
    }
    
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

- (void)createMediaSenders {
  RTCMediaConstraints *constraints = [self defaultMediaAudioConstraints];
  RTCAudioSource *source = [_factory audioSourceWithConstraints:constraints];
  RTCAudioTrack *track = [_factory audioTrackWithSource:source
                                                trackId:kARDAudioTrackId];
  RTCMediaStream *stream = [_factory mediaStreamWithStreamId:kARDMediaStreamId];
  [stream addAudioTrack:track];
  _localVideoTrack = [self createLocalVideoTrack];
  if (_localVideoTrack) {
    [stream addVideoTrack:_localVideoTrack];
  }
  [_peerConnection addStream:stream];
}

- (RTCVideoTrack *)createLocalVideoTrack {
  if ([_settings currentAudioOnlySettingFromStore]) {
    return nil;
  }

  RTCVideoSource *source = [_factory videoSource];

#if !TARGET_IPHONE_SIMULATOR
  RTCCameraVideoCapturer *capturer = [[RTCCameraVideoCapturer alloc] initWithDelegate:source];
  [_delegate appClient:self didCreateLocalCapturer:capturer];

#else
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
  if (@available(iOS 10, *)) {
    RTCFileVideoCapturer *fileCapturer = [[RTCFileVideoCapturer alloc] initWithDelegate:source];
    [_delegate appClient:self didCreateLocalFileCapturer:fileCapturer];
  }
#endif
#endif

  return [_factory videoTrackWithSource:source trackId:kARDVideoTrackId];
}

#pragma mark - Collider methods


#pragma mark - Defaults


 - (RTCMediaConstraints *)defaultMediaAudioConstraints {
   NSString *valueLevelControl = [_settings currentUseLevelControllerSettingFromStore] ?
       kRTCMediaConstraintsValueTrue :
       kRTCMediaConstraintsValueFalse;
   NSDictionary *mandatoryConstraints = @{ kRTCMediaConstraintsLevelControl : valueLevelControl };
   RTCMediaConstraints *constraints =
       [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                             optionalConstraints:nil];
   return constraints;
}


- (RTCMediaConstraints *)defaultAnswerConstraints {
  return [self defaultOfferConstraints];
}


- (RTCIceServer *)defaultSTUNServer {
    
    return [[RTCIceServer alloc] initWithURLStrings:@[@"stun:stun.l.google.com:19302",
                                                      @"stun:stun1.l.google.com:19302",
                                                      @"stun:stun2.l.google.com:19302",
                                                      @"stun:stun3.l.google.com:19302",
                                                      @"stun:stun4.l.google.com:19302"]
                                           username:@""
                                         credential:@""];
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
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultAudioTrack = localStream.audioTracks[0];
    [localStream removeAudioTrack:localStream.audioTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
    self.isAudioMuted = true;
}
- (void)unmuteAudioIn {
    NSLog(@"audio unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addAudioTrack:self.defaultAudioTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
//    if (_isSpeakerEnabled) [self enableSpeaker];
    self.isAudioMuted = false;
}

#pragma mark - Video mute/unmute
- (void)muteVideoIn {
    NSLog(@"video muted");
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultVideoTrack = localStream.videoTracks[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
    
    self.isVideoMuted = true;
}
- (void)unmuteVideoIn {
    NSLog(@"video unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addVideoTrack:self.defaultVideoTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
    
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






- (RTCMediaStream *)startLocalMedia
{
    RTCMediaStream *localMediaStream = [_factory mediaStreamWithStreamId:[self localStreamLabel]];
    
    //Audio setup
    BOOL audioEnabled = NO;
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusAuthorized || audioAuthStatus == AVAuthorizationStatusNotDetermined) {
        audioEnabled = YES;
        [self setupLocalAudio : localMediaStream];
    }
    
    //Video setup
    BOOL videoEnabled = NO;
    // The iOS simulator doesn't provide any sort of camera capture
    // support or emulation (http://goo.gl/rHAnC1) so don't bother
    // trying to open a local video track.
#if !TARGET_IPHONE_SIMULATOR
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusAuthorized || videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        videoEnabled = YES;
        [self setupLocalVideo : localMediaStream];
    }
    
#endif
    
    return localMediaStream;
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


- (void)setupLocalVideo : (RTCMediaStream *)localStream{
    [self setupLocalVideoWithConstraints:nil andLocalStream:localStream];
}

- (void)setupLocalVideoWithConstraints:(RTCMediaConstraints *)videoConstraints andLocalStream : (RTCMediaStream *)localStream {
    if(!localStream){
        return;
    }
    RTCVideoTrack *oldVideoTrack = [localStream.videoTracks firstObject];
    if(oldVideoTrack){
         //[_delegate appClient:self didReceiveLocalVideoTrack:oldVideoTrack];
        return;
    }
    
    /*if(oldVideoTrack){
        [localStream removeVideoTrack:oldVideoTrack];
    }*/
    

    RTCVideoTrack *videoTrack = [self localVideoTrackWithConstraints:videoConstraints];
    [localStream addVideoTrack:videoTrack];
    if(videoTrack){
        [_delegate appClient:self didReceiveLocalVideoTrack:videoTrack];
        return;
    }
    /*
    if (localStream && videoTrack) {
        RTCVideoTrack *oldVideoTrack = [localStream.videoTracks firstObject];
        if (oldVideoTrack) {
//            [localStream removeVideoTrack:oldVideoTrack];
        }
        [localStream addVideoTrack:videoTrack];
        //connect track with videoUI
        
        /*[self didReceiveLocalVideoTrack:videoTrack];*/
       /* [_delegate appClient:self didReceiveLocalVideoTrack:videoTrack];
    }*/
}

- (RTCVideoTrack *)localVideoTrackWithConstraints:(RTCMediaConstraints *)videoConstraints {
    /// NSString *cameraId = [self cameraDevice:self.cameraPosition];
    
    // NSAssert(cameraId, @"Unable to get camera id");
    //TODO: checkout Camera checnage
    RTCAVFoundationVideoSource* videoSource = [self.factory avFoundationVideoSourceWithConstraints:videoConstraints];
    //if (self.cameraPosition == AVCaptureDevicePositionBack) {
    //  [videoSource setUseBackCamera:YES];
    //}
    
    RTCVideoTrack *videoTrack = [self.factory videoTrackWithSource:videoSource trackId:[self videoTrackId]];
    
    return videoTrack;
}


- (NSString *)cameraDevice{
    //:(NBMCameraPosition)cameraPosition
    
    NSString *cameraID = nil;
    for (AVCaptureDevice *captureDevice in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            cameraID = [captureDevice localizedName];
            break;
        }
    }
    NSAssert(cameraID, @"Unable to get the front camera id");
    
    return cameraID;
}



- (RTCMediaConstraints *)videoConstraints
{
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:nil optionalConstraints:nil];
    return constraints;
}



#pragma mark - swap camera

- (RTCVideoTrack *)createLocalVideoTrackBackCamera {
    RTCVideoTrack *localVideoTrack = nil;
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE
    //AVCaptureDevicePositionFront
    NSString *cameraID = nil;
    for (AVCaptureDevice *captureDevice in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (captureDevice.position == AVCaptureDevicePositionBack) {
            cameraID = [captureDevice localizedName];
            break;
        }
    }
    NSAssert(cameraID, @"Unable to get the back camera id");
    
    // RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:cameraID];
    //  RTCMediaConstraints *mediaConstraints = [self defaultMediaStreamConstraints];
    //  RTCVideoSource *videoSource = [_factory videoSourceWithCapturer:capturer constraints:mediaConstraints];
    //localVideoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:videoSource];
    localVideoTrack = [self localVideoTrackWithConstraints: [self videoConstraints]];
#endif
    return localVideoTrack;
}


- (void)swapCameraToFront{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self localVideoTrackWithConstraints: [self videoConstraints]];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
        /*[self didReceiveLocalVideoTrack:localVideoTrack];*/
    }
    
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)swapCameraToBack{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrackBackCamera];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
        /*[self didReceiveLocalVideoTrack:localVideoTrack];*/
    }
    
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}


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
