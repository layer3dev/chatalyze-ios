//
//  VideoRendererView.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 06/09/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//


import UIKit
import TwilioVideo



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
        var image = convertI420FrameToImage(frame: frame)
        if(image != nil){
            return image
        }
        
        image = convertRawFrameToImage(frame: frame)
        return image
    }
    
    
    
    func convertRawFrameToImage(frame: VideoFrame) -> UIImage?{
    
        let ciImage = CIImage.init(cvImageBuffer: frame.imageBuffer, options: nil)
        let context = CIContext(options: nil)
        Log.echo(key: TAG, text: "width -> \(frame.width), height-> \(frame.height) & orientation -> \(frame.orientation.rawValue)")

        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return UIImage() }
        let image = getImage(cgImage: cgImage, frame : frame)
        return image
        
    }
    
  func convertI420FrameToImage(frame: VideoFrame) -> UIImage?{
        
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
        
        let success = convertI420toNV12(fromFrame: frame, toPixelBuffer: pixel)
    
        if(!success){
            return nil
        }
        
        Log.echo(key: TAG, text: "convertI420toNV12 success -> \(success)")
        
        let ciImage = CIImage.init(cvImageBuffer: pixel, options: nil)
        let context = CIContext(options: nil)
        
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return UIImage() }
        
        let image = getImage(cgImage: cgImage, frame : frame)
        //let image = UIImage(cgImage: cgImage, scale : 1.0, orientation: UIImage.Orientation.up)
        return image
    }
    
    func getImage(cgImage : CGImage, frame: VideoFrame) -> UIImage{
        return UIImage(cgImage : cgImage, scale : 1.0, orientation: getOrientation(frame: frame))
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
    
   
    
    
    private func getOrientation(frame : VideoFrame) -> UIImage.Orientation{
        let orientation = frame.orientation
        Log.echo(key: TAG, text: "orientation -> \(orientation)")
        
        switch orientation {
        case VideoOrientation.up:
            return UIImage.Orientation.up
        case VideoOrientation.down:
            return UIImage.Orientation.down
        case VideoOrientation.left:
            return UIImage.Orientation.right
        case VideoOrientation.right:
            return UIImage.Orientation.left
        default:
            return UIImage.Orientation.up
        
        }
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


