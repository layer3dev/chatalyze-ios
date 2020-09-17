//
//  I420Frame.m
//
//  Created by Joel Burke on 2/7/17.
//  Copyright © 2017 Kittehface Software. All rights reserved.
//
// Requires GoogleWebRTC CocoaPod
// Requires libyuv-iOS CocoaPod

#import "I420Frame.h"
#import <libyuv.h>
#import <WebRTC/RTCVideoFrameBuffer.h>
#import <WebRTC/RTCI420Buffer.h>
#import <WebRTC/RTCYUVPlanarBuffer.h>

@interface I420Frame()

@property NSUInteger chromaWidth;
@property NSUInteger chromaHeight;
@property uint8_t* yPlane;
@property uint8_t* uPlane;
@property uint8_t* vPlane;
@property NSInteger yPitch;
@property NSInteger uPitch;
@property NSInteger vPitch;
@property RTCVideoRotation rotation;

@end

@implementation I420Frame

@synthesize width = _width;
@synthesize height = _height;
@synthesize frameTimeS = _frameTimeS;
@synthesize chromaWidth = _chromaWidth;
@synthesize chromaHeight = _chromaHeight;
@synthesize yPlane = _yPlane;
@synthesize uPlane = _uPlane;
@synthesize vPlane = _vPlane;
@synthesize yPitch = _yPitch;
@synthesize uPitch = _uPitch;
@synthesize vPitch = _vPitch;
@synthesize rotation = _rotation;

- (instancetype)initWithRTCFrame:(RTCVideoFrame *)frame atTime:(CFAbsoluteTime)timeS {
    if (self = [super init]) {
        _width = 0;
        _height = 0;
        _chromaWidth = 0;
        _chromaHeight = 0;
        _yPlane = nil;
        _uPlane = nil;
        _vPlane = nil;
        _rotation = RTCVideoRotation_0;
        
        [self copyRTCFrame:frame atTime:timeS];
    }
    return self;
}

- (instancetype)initWithI420Frame:(I420Frame *)frame {
    if (self = [super init]) {
        _width = 0;
        _height = 0;
        _chromaWidth = 0;
        _chromaHeight = 0;
        _yPlane = nil;
        _uPlane = nil;
        _vPlane = nil;
        _rotation = RTCVideoRotation_0;
        
        if (frame) {
            [frame copyToI420Frame:self];
        }
    }
    return self;
}

- (void)dealloc {
    if (_yPlane) {
        free(_yPlane);
    }
    if (_uPlane) {
        free(_uPlane);
    }
    if (_vPlane) {
        free(_vPlane);
    }
}

- (void)copyRTCFrame:(RTCVideoFrame *)videoFrame atTime:(CFAbsoluteTime)timeS {
    @synchronized (self) {
        id<RTCYUVPlanarBuffer> frame = nil;
        if (videoFrame) {
            RTCVideoFrame *i420VideoFrame = [videoFrame newI420VideoFrame];
            
            if (i420VideoFrame) {
                id<RTCVideoFrameBuffer> buffer = [i420VideoFrame buffer];
                
                if (buffer) {
                    id<RTCI420Buffer> i420Buffer = [buffer toI420];
                    
                    if (i420Buffer) {
                        frame = (id<RTCYUVPlanarBuffer>)i420Buffer;
                    }
                }
            }
        }
        
        if (frame) {
            NSUInteger newWidth = [frame width];
            NSUInteger newHeight = [frame height];
            NSUInteger newChromaWidth = [frame chromaWidth];
            NSUInteger newChromaHeight = [frame chromaHeight];
            
            const uint8_t* frameYPlane = [frame dataY];
            const uint8_t* frameUPlane = [frame dataU];
            const uint8_t* frameVPlane = [frame dataV];
            
            if (!frameYPlane || !frameUPlane || !frameVPlane) {
                if (_yPlane) {
                    free(_yPlane);
                    _yPlane = nil;
                }
                if (_uPlane) {
                    free(_uPlane);
                    _uPlane = nil;
                }
                if (_vPlane) {
                    free(_vPlane);
                    _vPlane = nil;
                }
                _yPitch = [frame strideY];
                _uPitch = [frame strideU];
                _vPitch = [frame strideV];
            } else {
                if (!_yPlane || _width * _height != newWidth * newHeight) {
                    if (_yPlane) {
                        free(_yPlane);
                    }
                    _yPlane = malloc(newWidth * newHeight * sizeof(uint8_t));
                }
                
                if (!_uPlane || _chromaWidth * _chromaHeight != newChromaWidth * newChromaHeight) {
                    if (_uPlane) {
                        free(_uPlane);
                    }
                    _uPlane = malloc(newChromaWidth * newChromaHeight * sizeof(uint8_t));
                }
                
                if (!_vPlane || _chromaWidth * _chromaHeight != newChromaWidth * newChromaHeight) {
                    if (_vPlane) {
                        free(_vPlane);
                    }
                    _vPlane = malloc(newChromaWidth * newChromaHeight * sizeof(uint8_t));
                }
                
                _yPitch = [frame strideY];
                _uPitch = [frame strideU];
                _vPitch = [frame strideV];
                
                libyuv:I420Copy(frameYPlane, (int) _yPitch, frameUPlane, (int) _uPitch, frameVPlane, (int) _vPitch, _yPlane, (int) newWidth, _uPlane, (int) newChromaWidth, _vPlane, (int) newChromaWidth, (int) newWidth, (int) newHeight);
            }
            
            _width = newWidth;
            _height = newHeight;
            _frameTimeS = timeS;
            _chromaWidth = newChromaWidth;
            _chromaHeight = newChromaHeight;
            _rotation = [videoFrame rotation];
        }
    }
}

- (void)copyToI420Frame:(I420Frame *)frame {
    @synchronized (self) {
        if (frame) {
            if (_yPlane && _uPlane && _vPlane) {
                if (!frame.yPlane || frame.width * frame.height != _width * _height) {
                    if (frame.yPlane) {
                        free(frame.yPlane);
                    }
                    frame.yPlane = malloc(_width * _height * sizeof(uint8_t));
                }
                if (!frame.uPlane || frame.chromaWidth * frame.chromaHeight != _chromaWidth * _chromaHeight) {
                    if (frame.uPlane) {
                        free(frame.uPlane);
                    }
                    frame.uPlane = malloc(_chromaWidth * _chromaHeight * sizeof(uint8_t));
                }
                if (!frame.vPlane || frame.chromaWidth * frame.chromaHeight != _chromaWidth * _chromaHeight) {
                    if (frame.vPlane) {
                        free(frame.vPlane);
                    }
                    frame.vPlane = malloc(_chromaWidth * _chromaHeight * sizeof(uint8_t));
                }
                memcpy(frame.yPlane, _yPlane, _width * _height * sizeof(uint8_t));
                memcpy(frame.uPlane, _uPlane, _chromaWidth * _chromaHeight * sizeof(uint8_t));
                memcpy(frame.vPlane, _vPlane, _chromaWidth * _chromaHeight * sizeof(uint8_t));
            } else {
                if (frame.yPlane) {
                    free(frame.yPlane);
                    frame.yPlane = nil;
                }
                if (frame.uPlane) {
                    free(frame.uPlane);
                    frame.uPlane = nil;
                }
                if (frame.vPlane) {
                    free(frame.vPlane);
                    frame.vPlane = nil;
                }
            }
            
            frame.width = _width;
            frame.height = _height;
            frame.frameTimeS = _frameTimeS;
            frame.chromaWidth = _chromaWidth;
            frame.chromaHeight = _chromaHeight;
            frame.yPitch = _yPitch;
            frame.uPitch = _uPitch;
            frame.vPitch = _vPitch;
            frame.rotation = _rotation;
        }
    }
}

- (UIImage *)getUIImage {
    @synchronized (self) {
        NSUInteger size = _width * _height * 4;
        uint8_t *buffer = malloc(size);
        if ([self convertRGBA:buffer withSize:size]) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef bitmapContext = CGBitmapContextCreate(buffer, _width, _height, 8, _width * 4, colorSpace, kCGImageAlphaNoneSkipLast);
            
            CFRelease(colorSpace);
            
            CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
			
            UIImageOrientation orientation = UIImageOrientationUp;
			
            switch (_rotation) {
                case RTCVideoRotation_0: orientation = UIImageOrientationUp; break;
                case RTCVideoRotation_90: orientation = UIImageOrientationRight; break;
                case RTCVideoRotation_180: orientation = UIImageOrientationDown; break;
                case RTCVideoRotation_270: orientation = UIImageOrientationLeft; break;
            }
			
            UIImage *image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:orientation];
            
            CFRelease(cgImage);
            CFRelease(bitmapContext);
            free(buffer);
            
            return image;
        } else {
            free(buffer);
        }
    }
    return nil;
}

- (BOOL)convertRGBA:(uint8_t *)buffer withSize:(NSUInteger)size {
    if (buffer && _yPlane && _uPlane && _vPlane) {
        if (_width * _height * 4 == size) {
            libyuv:I420ToABGR(_yPlane, (int) _yPitch, _uPlane, (int) _uPitch, _vPlane, (int) _vPitch, buffer, (int) _width * 4, (int) _width, (int) _height);
            return YES;
        }
    }
    return NO;
}

@end
