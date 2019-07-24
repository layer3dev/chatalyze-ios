
//
//  RemoteVideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class RemoteVideoView: VideoView {
    
    @IBOutlet private var widthConstraint : NSLayoutConstraint?
    @IBOutlet private var heightConstraint : NSLayoutConstraint?
        
    
    private var streamSize : CGSize?
    private var containerSize : CGSize?
    
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
        
        Log.echo(key: "remote", text: "updateSize ->> \(size)")
        self.streamSize = size
        refreshRendererSize()
    }
    
    func refreshRendererSize(){
        
        guard let containerSize = self.containerSize
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
        Log.echo(key: "remote", text: "Stream way is \(isPortrait(size: streamSize))")
        
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
        
        UIView.animate(withDuration: 1.0, animations: {
            self.layoutIfNeeded()
        }) { (success) in
            
        }
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
