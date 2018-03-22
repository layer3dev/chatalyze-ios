//
//  CallerConnection.m
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

#import "CallerConnection.h"
#import "ARDAppClient+Internal.h"

@implementation CallerConnection

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

-(void)initialization{
    
}


- (void)initiateCall {
    [self createPeerConnection];
    
    [Log echoWithKey:@"peer" text:@"create offer"];
    // Send offer.
    __weak CallerConnection *weakSelf = self;
    [self.peerConnection offerForConstraints:[self defaultOfferConstraints]
                       completionHandler:^(RTCSessionDescription *sdp,
                                           NSError *error) {
                           
                           [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"%@ %@", @"offerForConstraints.", sdp.sdp]];
                           //CallerConnection *strongSelf = weakSelf;
                           [self peerConnection:self.peerConnection
                          didCreateSessionDescription:sdp
                                                error:error];
                       }];
    
}


- (void)peerConnection:(RTCPeerConnection *)peerConnection didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error {
    
     [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"didCreateSessionDescription"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"%@ %@", @"Failed to create session description.", error]];
            //todo: disconnect
            //todo: return error using delegate
            return;
        }
        
        [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"%@ %@", @"didCreateSessionDescription offerForConstraints.", sdp.sdp]];
        
        [peerConnection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
            //todo: send sdp offer
            if (error) {
                [Log echoWithKey:@"peer" text:[NSString stringWithFormat:@"%@ %@", @"Failed to setLocalDescription.", error]];
                //todo: return error using delegate
                return;
            }
            [Log echoWithKey:@"peer" text:@"setLocalDescription success."];
            
        }];
    });
}




@end
