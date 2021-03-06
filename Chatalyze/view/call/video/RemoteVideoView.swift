
//
//  RemoteVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class RemoteVideoView: VideoViewOld {
    
    private var frameRender = VideoFrameRenderer()

    @IBOutlet private var widthConstraint : NSLayoutConstraint?
    @IBOutlet private var heightConstraint : NSLayoutConstraint?
    
    private var streamSize : CGSize?
    private var containerSize : CGSize?
    
    var streamUpdationDelegate:UpdateStreamChangeProtocol?
    
    var TAG : String{
        get{
            return "RemoteVideoView"
        }
    }
    
    func recreateRenderer(){
        frameRender = VideoFrameRenderer()
    }
    
     
    override func getRenderer() -> VideoFrameRenderer{
        return frameRender
    }
    
    func updateContainerSize(containerSize : CGSize){
        
        Log.echo(key: self.TAG, text: "updateContainerSize ->> \(containerSize)")
        
        if(containerSize.width == 0 || containerSize.height == 0){
            return
        }
        self.containerSize = containerSize
        refreshRendererSize()
    }
    
    override func updateSize(size: CGSize){
        
        Log.echo(key: self.TAG, text: "updateSize ->> \(size)")
        self.streamSize = size
        self.streamUpdationDelegate?.updateForStreamPosition(isPortrait: isPortrait(size: size) ?? true)
        refreshRendererSize()
    }
    
    func refreshRendererSize(){
        
        guard let containerSize = self.containerSize
            else{
                Log.echo(key: self.TAG, text: "containerSize ->> nil")
                return
        }
        
        guard let streamSize = self.streamSize
            else{
                Log.echo(key: self.TAG, text: "streamSize ->> nil")
                return
        }
        
        Log.echo(key: self.TAG, text: "update aspect ->> nil")
        Log.echo(key: self.TAG, text: "containerSize ->> \(containerSize)")
        Log.echo(key: self.TAG, text: "streamSize ->> \(streamSize)")
        Log.echo(key: self.TAG, text: "Stream way is \(String(describing: isPortrait(size: streamSize)))")
        
        
        if let isStreamPortrait = isPortrait(size: streamSize) {
            if let isContainerPortrait = isPortrait(size: containerSize){
                if isStreamPortrait && isContainerPortrait{
                    
                    //Developer Y
                    //If stream and device both are portrait then video must be aspect fill.
                    
                    let newContainerSizeAfterFill = aspectFill(aspectRatio: streamSize, minimumSize: containerSize)
                    updateViewSize(size : newContainerSizeAfterFill)
                    return
                }
                
                //If stream and device both are landscape then video must be aspect fill.
                
                if !isStreamPortrait && !isContainerPortrait{
                    
                    //Developer Y
                    let newContainerSizeAfterFill = aspectFill(aspectRatio: streamSize, minimumSize: containerSize)
                    updateViewSize(size : newContainerSizeAfterFill)
                    return
                }
            }
        }
        
        //Initially implemented:-
        let aspectSize = AVMakeRect(aspectRatio: streamSize, insideRect: CGRect(origin: CGPoint.zero, size: containerSize))
        updateViewSize(size : aspectSize.size)
        return
    }
    
    
    
    
    private func updateViewSize(size: CGSize){
        self.layoutIfNeeded()
        
        self.widthConstraint?.constant = !size.width.isNaN ? size.width : 0
        self.heightConstraint?.constant = !size.height.isNaN ? size.height : 0
    }
    
    //Developer Y
    func isPortrait(size:CGSize)->Bool?{
        
        let minimumSize = size
        let mW = minimumSize.width
        let mH = minimumSize.height
        
        if( mH > mW ) {
            return true
        }
        else if( mW > mH ) {
            return false
        }
        return nil
    }
    
    //Developer Y
    
    func aspectFill(aspectRatio :CGSize, minimumSize: CGSize) -> CGSize {
        
        var minimumSize = minimumSize
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;
        
        if( mH > mW ) {
            minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW > mH ) {
            minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }
        
        return minimumSize;
    }
}
