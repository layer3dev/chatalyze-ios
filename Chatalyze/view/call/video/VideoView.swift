//
//  VideoView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoView: RTCEAGLVideoView {
    
    private var trackSize : CGSize = CGSize.zero
    
    private var frameListener : ((_ image: UIImage?) -> ())?
    private var isFrameRequired = false
    
    var TAG : String{
        get{
            return "LocalVideoView"
        }
    }

    enum orientation : Int{
        
        case undefined = 0
        case portrait = 1
        case landscape = 2
    }
    
    private var isLoaded = false;
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if(!isLoaded){
            
            isLoaded = true
            viewDidLayout()
        }
    }
    
    func getFrame(listener : @escaping ((_ frame: UIImage?) -> ())){
        self.frameListener = listener
        isFrameRequired = true
    }
    
    
    
    override func renderFrame(_ frame: RTCVideoFrame?) {
        super.renderFrame(frame)

        if(!isFrameRequired){
            return
        }

        guard let frame = frame
        else{
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
    
    
    
    private func frameToImage(frame: RTCVideoFrame) -> UIImage?{
        
        Log.echo(key: self.TAG, text: "frameToImage")
        let frameRenderer = I420Frame(rtcFrame: frame, atTime: Date().timeIntervalSinceNow)
        Log.echo(key: self.TAG, text: "got Frame Renderer")
        return frameRenderer?.getUIImage()
    }
    
    private func dispatchFrame(frame: UIImage){
        DispatchQueue.main.async {[weak self] in
            Log.echo(key: self?.TAG ?? "", text: "frame is ready")
            self?.frameListener?(frame)
            self?.frameListener = nil
            Log.echo(key: self?.TAG ?? "", text: "sent the frame")
        }
    }

    func viewDidLayout(){
        
        initialization()
        paintInterface()
    }

    func paintInterface(){        
    }
    
    
    private func initialization(){
        
         self.delegate = self
    }
    
    func updateSize(size: CGSize){
    }
}

extension VideoView : RTCVideoViewDelegate{
    
    func resetBounds(){
        self.updateSize(size: self.trackSize)
    }
    
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        
        Log.echo(key: self.TAG, text: "didChangeVideoSize --> \(size)")
        
//        if(size == CGSize.zero){
//            return
//        }
        
        if(size != CGSize.zero){
            self.trackSize = size
        }
       
        self.isHidden = false
        self.updateSize(size: size)
    }
    
    
}
