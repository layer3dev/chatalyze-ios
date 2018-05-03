
//
//  RTCSingletonStreamProtocol.h
//  Chatalyze
//
//  Created by Sumant Handa on 03/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTCSingletonStreamProtocol <NSObject>

- (void)didCreateLocalCapturer:(RTCCameraVideoCapturer * _Nullable)localCapturer;

@end
