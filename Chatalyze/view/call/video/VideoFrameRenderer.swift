//
//  VideoRendererView.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 06/09/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//


import UIKit
import TwilioVideo
//import libyuv

class VideoFrameRenderer : NSObject, VideoRenderer {

    func updateVideoSize(_ videoSize: CMVideoDimensions, orientation: VideoOrientation) {
        
    }
    
    
    private let TAG = "VideoFrameRenderer"
    
    
    private var frameListener : ((_ image: UIImage?) -> ())?
    private var isFrameRequired = false

   
    

    
    func getFrame(listener : @escaping ((_ frame: UIImage?) -> ())){
        self.frameListener = listener
        isFrameRequired = true
    }
    

    
    func renderFrame(_ frame: VideoFrame) {

        if(!isFrameRequired){
            return
        }

    
        isFrameRequired = false
        Log.echo(key: self.TAG, text: "fetch frame")


        DispatchQueue.global(qos: .userInteractive).async {[weak self] in

            guard let _ = self?.frameListener
            else{
                return
            }


            guard let image = self?.frameToImage(frame : frame)
                else{
                    return
            }

            Log.echo(key: self?.TAG ?? "", text: "got the image")

            self?.dispatchFrame(frame : image)
        }
    }
    
    func frameToImage(frame: VideoFrame) -> UIImage?{
                
        var pixelBuffer: CVPixelBuffer? = nil

        _ = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(frame.width),
                                         Int(frame.height),
                                         kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                         [:] as CFDictionary,
                                         &pixelBuffer);
        
        guard let pixel = pixelBuffer
            else{
                Log.echo(key : TAG, text : "pixel is nil")
                return nil
        }


        convertI420toNV12(fromFrame: frame, toPixelBuffer: pixel)
        
        let ciImage = CIImage.init(cvImageBuffer: pixel, options: nil)
        let context = CIContext(options: nil)
        
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return UIImage() }
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    @discardableResult
    fileprivate func convertI420toNV12(fromFrame frame: VideoFrame, toPixelBuffer pixelBuffer: CVPixelBuffer) -> Bool {
    
    
        CVPixelBufferLockBaseAddress(frame.imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        defer {
            CVPixelBufferUnlockBaseAddress(frame.imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        }
        
        let src_yAddress  = CVPixelBufferGetBaseAddressOfPlane(frame.imageBuffer, 0)?.assumingMemoryBound(to: UInt8.self)
        let src_uAddress  = CVPixelBufferGetBaseAddressOfPlane(frame.imageBuffer, 1)?.assumingMemoryBound(to: UInt8.self)
        let src_vAddress  = CVPixelBufferGetBaseAddressOfPlane(frame.imageBuffer, 2)?.assumingMemoryBound(to: UInt8.self)
        let dst_yAddress  = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)?.assumingMemoryBound(to: UInt8.self)
        let dst_uvAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1)?.assumingMemoryBound(to: UInt8.self)
        let src_yBytesPerRow  = Int32(CVPixelBufferGetBytesPerRowOfPlane(frame.imageBuffer, 0))
        let src_uBytesPerRow  = Int32(CVPixelBufferGetBytesPerRowOfPlane(frame.imageBuffer, 1))
        let src_vBytesPerRow  = Int32(CVPixelBufferGetBytesPerRowOfPlane(frame.imageBuffer, 2))
        let dst_yBytesPerRow  = Int32(CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0))
        let dst_uvBytesPerRow = Int32(CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1))
        let width = Int32(frame.width)
        let height = Int32(frame.height)
        
        let success = I420ToNV12(src_yAddress,
                                 src_yBytesPerRow,
                                 src_uAddress,
                                 src_uBytesPerRow,
                                 src_vAddress,
                                 src_vBytesPerRow,
                                 dst_yAddress,
                                 dst_yBytesPerRow,
                                 dst_uvAddress,
                                 dst_uvBytesPerRow,
                                 width,
                                 height
        )
        
        return success == 0
    }
    
    private func dispatchFrame(frame: UIImage){
        DispatchQueue.main.async {[weak self] in
            Log.echo(key: self?.TAG ?? "", text: "frame is ready")
            self?.frameListener?(frame)
            self?.frameListener = nil
            Log.echo(key: self?.TAG ?? "", text: "sent the frame")
        }
    }
    

}


