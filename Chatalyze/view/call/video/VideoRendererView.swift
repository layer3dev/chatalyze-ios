//
//  VideoRendererView.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 06/09/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//


import UIKit
import TwilioVideo

class VideoRendererView: VideoView {
    
    private let TAG = "VideoRendererView"
    
    
    private var frameListener : ((_ image: UIImage?) -> ())?
    private var isFrameRequired = false

   
    

 

    
    func getFrame(listener : @escaping ((_ frame: UIImage?) -> ())){
        self.frameListener = listener
        isFrameRequired = true
    }
    
 
    
    
    
    override func renderFrame(_ frame: VideoFrame) {
        super.renderFrame(frame)

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
    
    private func frameToImage(frame: VideoFrame) -> UIImage?{
        
        let ciImage = CIImage.init(cvImageBuffer: frame.imageBuffer)
        let context = CIContext(options: nil)
        
        guard let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
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


