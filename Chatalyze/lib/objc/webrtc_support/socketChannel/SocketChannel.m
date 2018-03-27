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
    // TODO(tkchin): move these to a configuration object.
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
}


-(void)registerListeners{
    
    [socketClient onEventSupportWithAction:@"iceCandidate" completion:^(NSDictionary<NSString *,id> * _Nullable data) {
        [self processCandidate : data];
    }];
    
    [socketClient onEventSupportWithAction:@"sdpOffer" completion:^(NSDictionary<NSString *,id> * _Nullable data) {
        [self processSDPOffer : data];
    }];
    
    [socketClient onEventSupportWithAction:@"description" completion:^(NSDictionary<NSString *,id> * _Nullable data) {
        
        [self processSDPAnswer : data];
        
        
    }];

}

-(void)emitAnswer:(RTCSessionDescription *)sdp{
    [self emitSDPWithAction:@"sdpAnswer" andSDP:sdp];
}


-(void)emitOffer:(RTCSessionDescription *)sdp{
    [self emitSDPWithAction:@"sendDescription" andSDP:sdp];
}

-(void)emitSDPWithAction:(NSString *)action andSDP:(RTCSessionDescription *)sdp{
    NSDictionary *sdpInfo = [sdp JSONDictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[@"sender"] = self.userId;
    data[@"receiver"] = self.receiverId;
    data[@"description"] = sdpInfo;
    data[@"type"] = @"sender";
    
    [self sendMessageWithAction:action andData:data];
}

-(void)emitCandidate:(RTCIceCandidate *)candidate{
    NSDictionary *candidateInfo = [candidate JSONDictionary];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[@"type"] = @"sender";
    data[@"sender"] = self.userId;
    data[@"receiver"] = self.receiverId;
    data[@"candidate"] = candidateInfo;
    
    
    [self sendMessageWithAction:@"candidate" andData:data];
}


- (void)sendMessageWithAction:(NSString *)action andData:(NSDictionary *)data {
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"id"] = action;
    params[@"data"] = data;
    
//    [socketClient emit];
    [socketClient emitSupportWithData:params];
}


-(void)processCandidate:(NSDictionary *)data{
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
    NSDictionary *sdp = data[@"description"];
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
}

@end
