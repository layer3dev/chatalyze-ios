//
//  I420Frame.h
//
//  Created by Joel Burke on 2/7/17.
//  Copyright © 2017 Kittehface Software. All rights reserved.
//
// Requires GoogleWebRTC CocoaPod
// Requires libyuv-iOS CocoaPod

#ifndef I420Frame_h
#define I420Frame_h

#import <Foundation/NSObject.h>
#import <UIKit/UIKit.h>
#import <WebRTC/RTCVideoFrame.h>

@interface I420Frame : NSObject

@property NSUInteger width;
@property NSUInteger height;
@property CFAbsoluteTime frameTimeS;

- (instancetype)initWithRTCFrame:(RTCVideoFrame *)frame atTime:(CFAbsoluteTime)timeS;
- (instancetype)initWithI420Frame:(I420Frame *)frame;

- (void)copyRTCFrame:(RTCVideoFrame *)frame atTime:(CFAbsoluteTime)timeS;

- (UIImage *)getUIImage;

@end

#endif /* I420Frame_h */