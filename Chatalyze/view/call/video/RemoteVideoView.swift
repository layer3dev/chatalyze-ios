
//
//  RemoteVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import AVFoundation


class RemoteVideoView: VideoViewOld {
    
    @IBOutlet private var widthConstraint : NSLayoutConstraint?
    @IBOutlet private var heightConstraint : NSLayoutConstraint?
    
    private var streamSize : CGSize?
    private var containerSize : CGSize?
    
    var streamUpdationDelegate:UpdateStreamChangeProtocol?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateContainerSize(containerSize : CGSize){
       
        Log.echo(key: "remote", text: "updateContainerSize ->> \(containerSize)")
        self.containerSize = containerSize
        refreshRendererSize()
    }

    override func updateSize(size: CGSize){
        
        Log.echo(key: "rotation", text: "updateSize ->> \(size) and contaibner size is \(self.streamUpdationDelegate?.getContainerSize())")
        
        print("Stream size in RemoteVideoView is \(size)")
        
        self.streamSize = size
        self.streamUpdationDelegate?.updateForStreamPosition(isPortrait: isPortrait(size: size) ?? true)
        refreshRendererSize()
    }
    
    func refreshRendererSize(){
        
        print("refreshing the render size \(self.streamSize) and the container size is \(self.streamUpdationDelegate?.getContainerSize())")
        
        guard let containerSize = self.streamUpdationDelegate?.getContainerSize()
            else{
                Log.echo(key: "remote", text: "containerSize ->> nil")
                return
        }
        
        guard let streamSize = self.streamSize
            else{
                Log.echo(key: "remote", text: "streamSize ->> nil")
                return
        }
        
        Log.echo(key: "remote", text: "update aspect ->> nil")
        Log.echo(key: "remote", text: "containerSize ->> \(containerSize)")
        Log.echo(key: "remote", text: "streamSize ->> \(streamSize)")
        Log.echo(key: "remote", text: "Stream way is \(String(describing: isPortrait(size: streamSize)))")
        
        
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
        
        
        print("Updating the size \(self.streamSize) and the container size is \(self.containerSize)")
        
        //Initially implemented:-
        let aspectSize = AVMakeRect(aspectRatio: streamSize, insideRect: CGRect(origin: CGPoint.zero, size: containerSize))
        print("Aspect size is  \(aspectSize)")

        updateViewSize(size : aspectSize.size)
        return
    }
    
    private func updateViewSize(size: CGSize){
        self.layoutIfNeeded()

        self.widthConstraint?.constant = !size.width.isNaN ? size.width : 0
        self.heightConstraint?.constant = !size.height.isNaN ? size.height : 0
        
        self.layoutIfNeeded()
        
        //don't need the animation
        /*UIView.animate(withDuration: 1.0, animations: {
            
            
        }) { (success) in
            
        }*/
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
