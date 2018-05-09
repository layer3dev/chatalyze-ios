//
//  CacheImageLoader.swift
//  BN PERKS
//
//  Created by Sumant Handa on 17/02/18.
//  Copyright © 2018 Mansa. All rights reserved.
//

import UIKit
import AVFoundation


class FrameExtractor: NSObject {
    
    
    var captureSession : AVCaptureSession?
    private let sessionQueue = DispatchQueue(label: "session queue")
    private let context = CIContext()
    
    var completion : ((_ image : UIImage?)->())?
    var videoOutput : AVCaptureVideoDataOutput?
    
    override init() {
        super.init()
    }
    
    init(captureSession : AVCaptureSession?, closure : ((_ image : UIImage?)->())?) {
        super.init()
        self.captureSession = captureSession
        self.completion = closure
    }

    func getScreenshot(){
        sessionQueue.async { [unowned self] in
            self.processGetScreenshot()
        }
    }
    
    func processGetScreenshot() {
        
        guard let captureSession = captureSession
            else{
                Log.echo(key: "frame", text: "captureSession is-> nil ")
                respondCompletion(image:nil)
                return
        }
        Log.echo(key: "frame", text: "addOutput -> status ")
        Log.echo(key: "frame", text: captureSession.isRunning)
        
        captureSession.beginConfiguration()
        let videoOutput = AVCaptureVideoDataOutput()
        self.videoOutput = videoOutput
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else {
            Log.echo(key: "frame", text: "no, you can't add output")
            captureSession.commitConfiguration()
            respondCompletion(image:nil)
            return
        }
        captureSession.addOutput(videoOutput)
        
       
    }
    
    
    // MARK: Sample buffer to UIImage conversion
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
            
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func respondCompletion(image : UIImage?){
        completion?(image)
        completion = nil
        guard let videoOutput = videoOutput
            else{
                return
        }
        captureSession?.removeOutput(videoOutput)
        captureSession = nil
        return
    }
}


extension FrameExtractor : AVCaptureVideoDataOutputSampleBufferDelegate{
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            respondCompletion(image:nil)
            return
            
        }
        DispatchQueue.main.async { [unowned self] in
            self.respondCompletion(image:uiImage)
        }
    }
}
