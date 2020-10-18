//
//  LocalCameraSource.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 18/10/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import TwilioVideo

class LocalCameraSource : NSObject{

    private var capturer : LocalCameraVideoCapturer?
    fileprivate let TAG = "LocalCameraSource"
    private var sinkList = [VideoSink]()
    
    weak var sink: VideoSink?{
        get{
            if(sinkList.count == 0){
                return nil
            }
            return sinkList[0]
        }
        set{
            guard let sinkValue = newValue
            else{
                return
            }
            sinkList.append(sinkValue)
        }
    }


    override init() {
        super.init()
        
        initialization()
    }
    
    private func initialization(){
        capturer = LocalCameraVideoCapturer()
    }
    
    
    func startCapturer(){
        Log.echo(key: TAG, text: "startCapturer")
        capturer?.start(listener: { (frame) in
            Log.echo(key: self.TAG, text: "frame received")
            
            for sink in self.sinkList{
                sink.onVideoFrame(frame)
            }
        })
    }
    
    func stop(){
        capturer?.stop()
    }


   

}

// MARK:- VideoSource
extension LocalCameraSource: VideoSource {
    
    
    var isScreencast: Bool {
        // We want fluid AR content, maintaining the original frame rate.
        return false
    }

    func requestOutputFormat(_ outputFormat: VideoFormat) {
        Log.echo(key: self.TAG, text: "requestOutputFormat")
        
        for sink in sinkList{
            sink.onVideoFormatRequest(outputFormat)
        }
       
    }
    
    
}




