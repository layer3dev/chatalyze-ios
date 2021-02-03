//
//  LocalCameraVideoCapturer.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 18/10/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import TwilioVideo

class LocalCameraVideoCapturer : NSObject{
    
    private var session : AVCaptureSession?
    fileprivate var listener : ((VideoFrame)->())?
    fileprivate var orientation = UIDeviceOrientation.portrait
    private var videoDataOutputQueue : DispatchQueue

    
    fileprivate let TAG = "LocalCameraVideoCapturer"
    
    override init() {
        let highQueue = DispatchQueue.global(qos: .userInteractive)
        videoDataOutputQueue = DispatchQueue(label: TAG, attributes: [], target: highQueue)

        super.init()

        
        initialization()
    }
    
    func start(listener : ((VideoFrame)->())?){
        Log.echo(key: TAG, text: "start")
        self.listener = listener
        session?.startRunning()
    }
    
    func stop(){
        session?.stopRunning()
        releaseSelf()
    }
    
    private func initialization(){
        session = AVCaptureSession()
        addListener()
        updateOrientation()
        configureCaptureSessionInput()
        configureCaptureSessionOutput()
    }
    
    private func configureCaptureSessionInput(){

        
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .front)
        else{
            return
        }
        
    
        
        guard let input = try? AVCaptureDeviceInput(device: device)
        else{
            return
        }
//        session?.sessionPreset = .hd1280x720
        session?.beginConfiguration()
        session?.addInput(input)
        session?.commitConfiguration()
        
    }
    
    private func configureCaptureSessionOutput(){
        let videoOutput = AVCaptureVideoDataOutput()
       videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
       
       // RosyWriter records videos and we prefer not to have any dropped frames in the video recording.
       // By setting alwaysDiscardsLateVideoFrames to NO we ensure that minor fluctuations in system load or in our processing time for a given frame won't cause framedrops.
       // We do however need to ensure that on average we can process frames in realtime.
       // If we were doing preview only we would probably want to set alwaysDiscardsLateVideoFrames to YES.
       videoOutput.alwaysDiscardsLateVideoFrames = true
       
        if (session?.canAddOutput(videoOutput) ?? false){
        session?.addOutput(videoOutput)
       }
    }
    
   
    
    private func addListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func releaseSelf(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onOrientationChange(){
        updateOrientation()
    }
    
    
    private func updateOrientation(){
        let newOrientation = UIDevice.current.orientation
        if(newOrientation != UIDeviceOrientation.faceUp && newOrientation != UIDeviceOrientation.faceDown){
            orientation = newOrientation
            return
        }
        
    }
    
    
}

extension LocalCameraVideoCapturer : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        if (CMSampleBufferGetNumSamples(sampleBuffer) != 1 || !CMSampleBufferIsValid(sampleBuffer) ||
              !CMSampleBufferDataIsReady(sampleBuffer)) {
            return;
          }
        guard let rawBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else{
            return
        }
        
        let pixelBuffer = rawBuffer as CVPixelBuffer
         

        let orientation = getRotation()
    
    
        let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        
        guard let frame = VideoFrame(timestamp: timeStamp, buffer: pixelBuffer, orientation: orientation)
        else{
            return
        }
        
        listener?(frame)
        

    }
    
    
    private func getRotation() -> VideoOrientation{
        switch (orientation) {
        case UIDeviceOrientation.portrait:
             return VideoOrientation.left;
        case UIDeviceOrientation.portraitUpsideDown:
            return VideoOrientation.right;
        case UIDeviceOrientation.landscapeLeft:
            return VideoOrientation.down
        case UIDeviceOrientation.landscapeRight:
            return VideoOrientation.up
        default:
            return VideoOrientation.left
          }
        
    }
    
    
}
