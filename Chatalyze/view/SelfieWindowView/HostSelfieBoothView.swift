//
//  HostSelfieBoothView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 29/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import TwilioVideo

class HostSelfieBoothView: SelfieWindowView {
    
    private let TAG = "HostSelfieBoothView"
    
   @IBOutlet var containerWidthAnchor : NSLayoutConstraint?
   @IBOutlet var conatinerheightAnchor : NSLayoutConstraint?
    
    @IBOutlet var memoryImage : UIImageView?
    
    @IBOutlet var localSteamingVideo : VideoView?
    @IBOutlet var  remoteVideoView : RemoteVideoView?

    private var trackSize : CGSize = CGSize.zero
    var isStreamPortraitPosition:Bool = true
    
    // size for iPad
    var widthSize : CGFloat =  0.8
    var heightSize: CGFloat =  0.4
    
    override func viewDidLayout() {
        super.viewDidLayout()
        initialization()
        handleViewConstarints()
        paintInterface()
    }
    
    private func initialization(){
        self.localSteamingVideo?.delegate = self
        self.remoteVideoView?.streamUpdationDelegate = self
        remoteVideoView?.updateContainerSize(containerSize: self.bounds.size)
    }
    
   
    
    var localVideoRenderer:VideoFrameRenderer?{
        return nil
    }
    
    func writeLocalStream(mediaPackage : CallMediaTrack?){
        guard let localPreviewView = self.localSteamingVideo else{
            Log.echo(key: "yud", text: "Empty localCameraPreviewView")
            return
        }
        
        let rander = getRenderer()
        if  mediaPackage?.mediaTrack != nil{
            mediaPackage?.mediaTrack?.previewTrack.videoTrack?.removeRenderer(localPreviewView)
            mediaPackage?.mediaTrack?.previewTrack.videoTrack?.addRenderer(localPreviewView)
            mediaPackage?.mediaTrack?.previewTrack.videoTrack?.removeRenderer(rander)
            mediaPackage?.mediaTrack?.previewTrack.videoTrack?.addRenderer(rander)
        }
    }
    
    func handleViewConstarints(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.conatinerheightAnchor?.isActive = false
            self.containerWidthAnchor?.isActive = false
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 550, height: 550))
        }else{
            self.conatinerheightAnchor?.isActive = false
            self.containerWidthAnchor?.isActive = false
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 350, height: 350))
        }
        layoutIfNeeded()
    }
    func paintInterface(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.layer.cornerRadius = 16
        }else{
            self.layer.cornerRadius = 12
        }
    }
        
    override func setSelfieImage(with image:UIImage?){
        
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        self.memoryImage?.image = image
        self.streamStackViews?.isHidden = true
        self.selfieActionContainer?.enableRetakeAndSave()
    }
    
    override func show( with mediaPackage : CallMediaTrack?,remoteStream : RemoteVideoTrack?){
        self.memoryImage?.image = nil
        self.streamStackViews?.isHidden = false
        writeLocalStream(mediaPackage: mediaPackage)

        self.selfieActionContainer?.enableCamera()
        self.isHidden = false
    }
    
    func updateSize(size: CGSize){
        
        print("calling updateSize")
    }
    
    func getRenderer() -> VideoFrameRenderer{
        return VideoFrameRenderer()
    }
    
    func getFrame(listener : @escaping ((_ frame: UIImage?) -> ())){
        Log.echo(key: TAG, text: "request frame")
        getRenderer().getFrame{(frame) in
            Log.echo(key: self.TAG, text: "got the frame \(frame)" )
            listener(frame)
        }
    }
    
    
}

extension HostSelfieBoothView : VideoViewDelegate,VideoRenderer{

    func renderFrame(_ frame: VideoFrame) {
        print("getting the frame")
    }
    
    func updateVideoSize(_ videoSize: CMVideoDimensions, orientation: VideoOrientation) {
    }
   
    func videoViewDidReceiveData(view: VideoView) {
        
        let dimensions = view.videoDimensions
        let height = CGFloat(dimensions.height)
        let width = CGFloat(dimensions.width)
        let obtainedSize =  CGSize(width: width, height: height)
        
        if(obtainedSize != CGSize.zero){
            self.trackSize = obtainedSize
        }
        
        Log.echo(key: "Twill", text: "Updating the size videoViewDidReceiveData \(self.trackSize) and the obtained size is \(obtainedSize)")
        self.updateSize(size: obtainedSize)
    }
    
    
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        
        Log.echo(key: "render", text: "didChangeVideoSize --> \(dimensions)")
        
        print("videoViewDimensionsDidChange is \(dimensions)")
        
        let height = CGFloat(dimensions.height)
        let width = CGFloat(dimensions.width)
        let obtainedSize =  CGSize(width: width, height: height)
        
        if(obtainedSize != CGSize.zero){
            self.trackSize = obtainedSize
        }
        
        Log.echo(key: "Twill", text: "Updating the size of \(self.trackSize) and the obtained size is \(obtainedSize)")
        
        self.updateSize(size: obtainedSize)
    }
    
    func resetBounds(){
        
        self.updateSize(size: self.trackSize)
    }
    


}

extension HostSelfieBoothView:UpdateStreamChangeProtocol{
   
    func updateForStreamPosition(isPortrait:Bool){
        
        Log.echo(key: "rotation", text: "Stream updation is \(isPortrait)")
        
        isStreamPortraitPosition = isPortrait

    }
    
    func getContainerSize()->CGSize{
        return self.frame.size
    }
}
