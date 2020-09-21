//
//  UserVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import SDWebImage
import AVFoundation
import YoutubePlayer_in_WKWebView

class UserVideoRootView: UserVideoLayoutView {
    
    //@IBOutlet var userCallInfoContainer : UserCallInfoContainerView?
    //let testView = MemoryFrame()
    @IBOutlet var requestAutographButton : RequestAutographContainerView?
    //@IBOutlet var callInfoContainer : UserCallInfoContainerView?
    var extractor : FrameExtractor?
    @IBOutlet var youtubeContainerView : YoutubeContainerView?
    let TAG = "UserVideoRootView"
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     
     */
    
    //    func getSnapshot(info:EventInfo?,completion:@escaping ((_ image:UIImage?)->())){
    //
    //        testView.userPic?.sd_setImage(with: URL(string: (info?.user?.profileImage ?? "")), placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
    //            DispatchQueue.main.async {
    //
    //                if error == nil {
    //
    //                    self.getPostImageSnapshot(info: info,hostImage:image) { (image) in
    //                        completion(image)
    //                    }
    //                }else{
    //
    //                    self.getPostImageSnapshot(info: info,hostImage:UIImage(named: "blackUser")) { (image) in
    //                        completion(image)
    //                    }
    //                }
    //            }
    //        })
    //    }
    
    
    //    @objc override func getPostImageSnapshot(info:EventInfo?,hostImage:UIImage?,completion:((_ image:UIImage?)->())){
    //
    //        guard let remoteView = remoteVideoView
    //            else{
    //                completion(nil)
    //                return
    //        }
    //
    //        guard let localView = localVideoView
    //            else{
    //                completion(nil)
    //                return
    //        }
    //
    //        guard let localImage = getSnapshot(view : localView)
    //            else{
    //                completion(nil)
    //                return
    //        }
    //
    //        guard let remoteImage = getSnapshot(view : remoteView)
    //            else{
    //                completion(nil)
    //                return
    //        }
    //
    //        guard let finalImage = mergeImage(remote: remoteImage, local: localImage)
    //            else{
    //                completion(nil)
    //                return
    //        }
    //
    //        let isPortraitInSize = isPortrait(size: finalImage.size)
    //
    //        Log.echo(key: "yud", text: "is image is portrait \(String(describing: isPortraitInSize))")
    //
    //        testView.isPortraitInSize = isPortraitInSize ?? true
    //
    //
    //
    //
    ////        if isPortraitInSize ?? true{
    ////            testView.frame.size = CGSize(width: 636, height: 1130)
    ////        }else{
    ////            testView.frame.size = CGSize(width: 1024, height: 576)
    ////        }
    //        let size = frameSize(childSize: finalImage.size)
    //        Log.echo(key: TAG, text: "memory size -> \(size)")
    //        testView.frame.size = size
    //
    //        testView.screenShotPic?.image = finalImage
    //        testView.userPic?.image = hostImage
    //        testView.name?.text = ("Chat with ") + (info?.user?.firstName ?? "")
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    //        dateFormatter.dateFormat = "MMM dd, yyyy"
    //        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    //        let comingDate = info?.startDate ?? Date()
    //        let requireDate = dateFormatter.string(from: comingDate)
    //        testView.date?.text = "\(requireDate)"
    //        completion(getSnapshot(view: testView))
    //        // return finalImage
    //    }
    
    private func frameSize(childSize : CGSize) -> CGSize{
        Log.echo(key: TAG, text: "childSize -> \(childSize)")
        let constant = CGFloat(1200)
        let size = childSize
        
        let isViewPortrait = isPortrait(size: size) ?? true
        
        let aspect = size.width/size.height
        if(isViewPortrait && size.height >= constant){
            return size
        }
        if(!isViewPortrait && size.width >= constant){
            return size
        }
        if(isViewPortrait){
            return CGSize(width: aspect * constant, height: constant)
        }
        
        return CGSize(width: constant, height: constant/aspect)
        
    }
    
        
    
    private func getTargetSize(remote : UIImage, local : UIImage)->CGSize{
        
        var remoteInfo = (size : remote.size, orientation : VideoViewOld.orientation.undefined)
        
        var localInfo = (size : local.size, orientation : VideoViewOld.orientation.undefined)
        
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
    
    
    override func animateHeader() {
        
        if isStatusBarhiddenDuringAnimation == false {
            
            self.delegateCutsom?.visibleAnimateStatusBar()
            isStatusBarhiddenDuringAnimation = true
            
            UIView.animate(withDuration: 0.25) {
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5.0)
                
                self.layoutIfNeeded()
            }
            return
        }
        
        isStatusBarhiddenDuringAnimation = false
        
        var isNotch = false
        var notchHeight:CGFloat = 0.0
        
        print("updated height ios \(UIApplication.shared.statusBarFrame.size.height)")
        
        if (UIApplication.shared.statusBarFrame.size.height > 21.0) && (UIDevice.current.userInterfaceIdiom == .phone){
            
            isNotch = true
            notchHeight = UIApplication.shared.statusBarFrame.size.height
        }
        
        self.delegateCutsom?.hidingAnimateStatusBar()
        UIView.animate(withDuration: 0.25) {
            
            if isNotch == true{
                
                print("showing notch device")
                self.headerTopConstraint?.constant = (notchHeight+5.0)
                self.layoutIfNeeded()
                
            }else{
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5.0)
                self.layoutIfNeeded()
                
            }
            
            
            //            self.layoutIfNeeded()
        }
    }
    
    
    
    //Developer Y
    //    func isPortrait(size:CGSize)->Bool?{
    //
    //        let minimumSize = size
    //        let mW = minimumSize.width
    //        let mH = minimumSize.height
    //
    //        if( mH > mW ) {
    //            return true
    //        }
    //        else if( mW > mH ) {
    //            return false
    //        }
    //        return nil
    //    }
    //}
    
    override func mergePicture(local : UIImage, remote : UIImage) -> UIImage?{
        return self.mergeImage(hostPicture: remote, userPicture: local)
    }
    
    
}
