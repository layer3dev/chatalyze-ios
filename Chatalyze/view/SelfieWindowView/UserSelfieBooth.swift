//
//  UserSelfieBooth.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 29/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import TwilioVideo


class UserSelfieBooth: SelfieWindowView {
    
    private let TAG = "UserSelfieBooth"
    private var trackSize : CGSize = CGSize.zero
    @IBOutlet var containerWidthAnchor : NSLayoutConstraint?
    @IBOutlet var conatinerheightAnchor : NSLayoutConstraint?
    @IBOutlet var memoryImage : UIImageView?
    @IBOutlet var localSteamingVideo : VideoView?
    @IBOutlet var remoteStreamVideo : RemoteVideoView?

    
    
    // size for iPad
    var widthSize : CGFloat =  0.8
    var heightSize: CGFloat =  0.4
    
    override func viewDidLayout() {
        super.viewDidLayout()
        handleViewConstarints()
        paintInterface()
    
    }
    
    private func initialization(){
        self.localSteamingVideo?.delegate = self
    }

    func writeLocalStream(mediaPackage : CallMediaTrack?){
        guard let localPreviewView = self.localSteamingVideo else {
            Log.echo(key: "yud", text: "Empty localCameraPreviewView")
            return
        }
        localSteamingVideo?.shouldMirror = true
        localSteamingVideo?.contentMode = .scaleAspectFill
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
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 580, height: 580))
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
    // shows selfieBooth
        override func show( with mediaPackage : CallMediaTrack?,remoteStream : RemoteVideoTrack?){
            self.memoryImage?.image = nil
            self.streamStackViews?.isHidden = false
            writeLocalStream(mediaPackage: mediaPackage)
            self.selfieActionContainer?.enableCamera()
            self.isHidden = false
        }
//        writeLocalStream(mediaPackage: mediaPackage)
//        guard let remotePreviewView = self.remoteStreamVideo else{
//            Log.echo(key: "yud", text: "Empty localCameraPreviewView")
//            return
//        }
//        let rander = getRenderer()
//        remoteStream?.addRenderer(remotePreviewView)
//        remoteStream?.addRenderer(rander)
//    }
    
    // will set image on selfie frame
    override func setSelfieImage(with image: UIImage?) {
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        memoryImage?.image = image
        self.streamStackViews?.isHidden = true
    }
 
    override func hide(){
        self.memoryImage?.image = nil
        self.isHidden = true
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

extension UserSelfieBooth : VideoViewDelegate,VideoRenderer{

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

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
