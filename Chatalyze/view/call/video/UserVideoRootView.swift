//
//  UserVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class UserVideoRootView: UserVideoLayoutView {
    
    @IBOutlet var requestAutographButton : RequestAutographContainerView?
    @IBOutlet var callInfoContainer : UserCallInfoContainerView?
    var extractor : FrameExtractor?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    func getSnapshot()->UIImage?{
        
        guard let remoteView = remoteVideoView
            else{
                return nil
        }
        
        guard let localView = localVideoView
            else{
                return nil
        }
        
        guard let localImage = getSnapshot(view : localView)
            else{
                return nil
        }
        
        guard let remoteImage = getSnapshot(view : remoteView)
            else{
                return nil
        }
        
        
        guard let finalImage = mergeImage(remote: remoteImage, local: localImage)
            else{
            return nil
        }
        
        return finalImage
    }
    
    
    private func mergeImage(remote : UIImage, local : UIImage)->UIImage?{
        let size = remote.size
        let localSize = CGSize(width: size.width/4, height: size.height/4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        remote.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        local.draw(in: CGRect(x: (size.width - localSize.width), y: (size.height - localSize.height), width: localSize.width, height: localSize.height))
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    private func getTargetSize(remote : UIImage, local : UIImage)->CGSize{
        
        var remoteInfo = (size : remote.size, orientation : VideoView.orientation.undefined)
        var localInfo = (size : local.size, orientation : VideoView.orientation.undefined)
        

        
        let targetSize = CGSize(width: remoteInfo.size.width/4, height: remoteInfo.size.height/4)
        
        if(remoteInfo.size.width > remoteInfo.size.height){
            remoteInfo.orientation = .landscape
        }else{
            remoteInfo.orientation = .portrait
        }
        
        if(localInfo.size.width > localInfo.size.height){
            localInfo.orientation = .landscape
        }else{
            localInfo.orientation = .portrait
        }
        
        let localHeightAspect = localInfo.size.height/localInfo.size.width
        
        if(localInfo.orientation == .landscape){
            let width =  targetSize.width
            let height = localHeightAspect*width
            return CGSize(width: width, height: height)
        }
        
        let localWidthAspect = localInfo.size.width/localInfo.size.height
        if(localInfo.orientation == .portrait){
            let height = targetSize.height
            let width = localWidthAspect*height
            
            return CGSize(width: width, height: height)
        }
    
        return CGSize.zero
    }

    
    private func getSnapshot(view : UIView)->UIImage?{
        let bounds = view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

}
