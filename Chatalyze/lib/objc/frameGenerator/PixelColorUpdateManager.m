//
//  PixelColorUpdateManager.m
//  Chatalyze
//
//  Created by Gunjot Singh on 06/06/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

#import "PixelColorUpdateManager.h"

@implementation PixelColorUpdateManager

+(void)blackColor:(CVPixelBufferRef)pixelBuffer{
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    UInt32* buffer = (UInt32*)CVPixelBufferGetBaseAddress(pixelBuffer);
    for ( unsigned long i = 0; i < width * height; i++ )
    {
        buffer[i] = CFSwapInt32HostToBig(0x000000ff);
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

@end
