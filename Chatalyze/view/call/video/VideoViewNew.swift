//
//  VideoViewNew.swift
//  Chatalyze
//
//  Created by Yudhisther on 17/08/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//


import UIKit
import TwilioVideo

class VideoViewOld: UIView {
    
    private var trackSize : CGSize = CGSize.zero
    @IBOutlet var streamingVideoView:VideoView?

    enum orientation : Int{
        
        case undefined = 0
        case portrait = 1
        case landscape = 2
    }
    
    private var isLoaded = false

    override func layoutSubviews(){
        super.layoutSubviews()
        
        if(!isLoaded){
            
            isLoaded = true
            viewDidLayout()
        }
    }

    func viewDidLayout(){
        
        initialization()
        paintInterface()
    }

    func paintInterface(){
    }
        
    private func initialization(){
        self.streamingVideoView?.delegate = self
    }
    
    func updateSize(size: CGSize){
        
        print("calling updateSize")
    }
}

extension VideoViewOld : VideoViewDelegate{
    
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
