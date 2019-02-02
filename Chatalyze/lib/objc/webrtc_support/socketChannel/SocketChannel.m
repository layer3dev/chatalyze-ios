//
//  SocketChannel.m
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//


#import "SocketChannel.h"
#import "WebRTC/RTCLogging.h"
#import "SRWebSocket.h"
#import "ARDSignalingMessage.h"
#import "ARDUtilities.h"


static NSString const *kARDWSSMessageErrorKey = @"error";
static NSString const *kARDWSSMessagePayloadKey = @"msg";


@implementation SocketChannel{
    SocketClient *socketClient;
    SocketListener *socketListener;
    CallLogger *callLogger;
    Boolean isSdpExchanged;
    // TODO(tkchin): move these to a configuration object.
}


- (instancetype)initWithEventId : (NSString *)eventId {
    if (self = [super init]) {
        // Initialize self
        self.eventId = eventId;
        [self initialize];
        [self registerListeners];
        
    }
    return self;
}

-(Boolean)isSignallingCompleted{
    return isSdpExchanged;
}


- (instancetype)init {
    if (self = [super init]) {
        // Initialize self
        [self initialize];
        [self registerListeners];
    }
    return self;
}

-(void)initialize{
    socketClient = [SocketClient sharedInstance];
    socketListener = [socketClient createListener];
    
    //todo: sending hashedId, which is wrong would cause crash ?
    callLogger = [[CallLogger alloc] initWithSessionId:self.eventId targetUserId:self.receiverId];
}


-(NSString *)selfDesignation{
    SignedUserInfo *userInfo = [SignedUserInfo sharedInstance];
    if(userInfo.role == roleTypeAnalyst){
        return @"receiver";
    }
    return @"sender";
}


-(NSString *)targetDesignation{
    SignedUserInfo *userInfo = [SignedUserInfo sharedInstance];
    if(userInfo.role == roleTypeAnalyst){
        return @"sender";
    }
    return @"receiver";
}

-(void)registerListeners{
    
    [socketListener onEventSupportWithAction:@"iceCandidate" completion:^(NSDictionary<NSString *,id> * _Nullable data) {
        if(self->socketClient == nil){
            return;
        }
        [self processCandidate : data];
    }];
    
    
    [socketListener onEventSupportWithAction:@"description" completion:^(NSDictionary<NSString *,id> * _Nullable data) {
        
        if(self->socketClient == nil){
            return;
        }
        
        BOOL isSelf = [self verifyIfMessageForSelf:data];
        if(!isSelf){
            return;
        }
        
        NSDictionary *packedData = data[@"description"];
        NSString *type = packedData[@"type"];
        
        if([type isEqualToString:@"offer"]){
            [self processSDPOffer : packedData];
            return;
        }
        self->isSdpExchanged = true;
        [self processSDPAnswer : packedData];
    }];

}

-(void)emitAnswer:(RTCSessionDescription *)sdp{
    isSdpExchanged = true;
    [callLogger logSdpWithType:@"answer" sdp:[sdp JSONDictionary]];
    [self emitSDPWithAction:@"sendDescription" andSDP:sdp];
}


-(void)emitOffer:(RTCSessionDescription *)sdp{
    [callLogger logSdpWithType:@"offer" sdp:[sdp JSONDictionary]];
    [self emitSDPWithAction:@"sendDescription" andSDP:sdp];
    
}

-(void)emitSDPWithAction:(NSString *)action andSDP:(RTCSessionDescription *)sdp{
    NSDictionary *sdpInfo = [sdp JSONDictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[[self selfDesignation]] = self.userId;
    data[[self targetDesignation]] = self.receiverId;
    data[@"description"] = sdpInfo;
    data[@"type"] = [self selfDesignation];
    
    [self sendMessageWithAction:action andData:data];
}

-(void)emitCandidate:(RTCIceCandidate *)candidate{
    NSDictionary *candidateInfo = [candidate JSONDictionary];
    [callLogger logCandidateWithCandidate:candidateInfo];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[@"type"] = [self selfDesignation];
    data[[self selfDesignation]] = self.userId;
    data[[self targetDesignation]] = self.receiverId;
    data[@"candidate"] = candidateInfo;
    [self sendMessageWithAction:@"sendIceCandidate" andData:data];
}


- (void)sendMessageWithAction:(NSString *)action andData:(NSDictionary *)data {
    [socketClient emitWithId:action data:data];
}

-(BOOL)verifyIfMessageForSelf:(NSDictionary *)data{
    
    [Log echoWithKey:@"_connection_" text:[NSString stringWithFormat:@"myId --> %@, receiverId => %@", self.userId, self.receiverId]];
    
    NSString *targetDesignation = [self targetDesignation];
     [Log echoWithKey:@"_connection_" text:[NSString stringWithFormat:@"targetDesignation --> %@", targetDesignation]];
    
    NSString *receivedSelfHashedId = data[@"sender"];
    [Log echoWithKey:@"_connection_" text:[NSString stringWithFormat:@"receivedSelfHashedId --> %@", receivedSelfHashedId]];
    
    
    if(![self.receiverId isEqualToString:receivedSelfHashedId]){
        [Log echoWithKey:@"_connection_" text:@"message NOT FOR me"];
        return false;
    }
    
    [Log echoWithKey:@"_connection_" text:@"message for me"];
    
    return true;
}


-(void)processCandidate:(NSDictionary *)data{

    BOOL isSelf  = [self verifyIfMessageForSelf:data];
    if(!isSelf){
        return;
    }
    NSDictionary *candidateDict = data[@"candidate"];
    RTCIceCandidate *candidate = [RTCIceCandidate candidateFromJSONDictionary:candidateDict];
     [self.listener processCandidate:candidate];
}


-(void)processSDPOffer:(NSDictionary *)data{
    
    RTCSessionDescription *description = [self parseSdp:data];
    [self.listener processSDPOffer:description];
}

-(void)processSDPAnswer:(NSDictionary *)data{
    
    RTCSessionDescription *description = [self parseSdp:data];
    [self.listener processSDPAnswer:description];
}


-(RTCSessionDescription *)parseSdp:(NSDictionary *)data{
    NSDictionary *sdp = data;
    RTCSessionDescription *description =
    [RTCSessionDescription descriptionFromJSONDictionary:sdp];
    return description;
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSString *messageString = message;
    NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                    options:0
                                                      error:nil];
    if (![jsonObject isKindOfClass:[NSDictionary class]]) {
        RTCLogError(@"Unexpected message: %@", jsonObject);
        return;
    }
    NSDictionary *wssMessage = jsonObject;
    NSString *errorString = wssMessage[kARDWSSMessageErrorKey];
    if (errorString.length) {
        RTCLogError(@"WSS error: %@", errorString);
        return;
    }
    
    NSString *payload = wssMessage[kARDWSSMessagePayloadKey];
    ARDSignalingMessage *signalingMessage =
    [ARDSignalingMessage messageFromJSONString:payload];
    RTCLog(@"WSS->C: %@", payload);
    //[_delegate channel:self didReceiveMessage:signalingMessage];
}

-(void)disconnect{
    self.listener = nil;
    socketClient = nil;
    [socketListener releaseListener];
    socketListener = nil;
}

@end
