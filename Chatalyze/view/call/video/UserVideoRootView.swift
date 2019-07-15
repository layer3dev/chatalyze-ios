//
//  UserVideoRootView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class UserVideoRootView: UserVideoLayoutView {
 
    let testView = MemoryFrame()
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
    
    func getSnapshot(info:EventInfo?,completion:@escaping ((_ image:UIImage?)->())){
        
        testView.userPic?.sd_setImage(with: URL(string: (info?.user?.profileImage ?? "")), placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
            DispatchQueue.main.async {
                
                if error == nil {
                    
                    self.getPostImageSnapshot(info: info,hostImage:image) { (image) in
                        completion(image)
                    }
                    
                }else{
                    
                    self.getPostImageSnapshot(info: info,hostImage:UIImage(named: "orangePup")) { (image) in
                        completion(image)
                    }
                }
            }
        })
    }
    
    func getPostImageSnapshot(info:EventInfo?,hostImage:UIImage?,completion:((_ image:UIImage?)->())){
        
        guard let remoteView = remoteVideoView
            else{
                completion(nil)
                return
        }
        
        guard let localView = localVideoView
            else{
                completion(nil)
                return
        }
        
        guard let localImage = getSnapshot(view : localView)
            else{
                completion(nil)
                return
        }
        
        guard let remoteImage = getSnapshot(view : remoteView)
            else{
                completion(nil)
                return
        }
        
        guard let finalImage = mergeImage(remote: remoteImage, local: localImage)
            else{
                completion(nil)
                return
        }
        
        let isPortraitInSize = isPortrait(size: finalImage.size)
        
        Log.echo(key: "yud", text: "is image is portrait \(String(describing: isPortraitInSize))")
        
        testView.isPortraitInSize = isPortraitInSize
        if isPortraitInSize ?? true{
            testView.frame.size = CGSize(width: 636, height: 1130)
        }else{
            testView.frame.size = CGSize(width: 1024, height: 576)
        }
        testView.screenShotPic?.image = finalImage
        testView.userPic?.image = hostImage
        testView.name?.text = ("Chat with ") + (info?.user?.firstName ?? "")       
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let comingDate = info?.startDate ?? Date()
        let requireDate = dateFormatter.string(from: comingDate)
        testView.date?.text = "\(requireDate)"
        completion(getSnapshot(view: testView))
       // return finalImage
    }
    
    
    private func mergeImage(remote : UIImage, local : UIImage)->UIImage?{
        
        let size = remote.size
        let localSize = local.size
        
        let maxConstant = size.width > size.height ? size.width : size.height
        
        let localContainerSize = CGSize(width: maxConstant/4, height: maxConstant/4)
        
        let aspectSize = AVMakeRect(aspectRatio: localSize, insideRect: CGRect(origin: CGPoint.zero, size: localContainerSize))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        remote.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
       
        //local.draw(in: CGRect(x: (size.width - aspectSize.width+20), y: (size.height - aspectSize.height), width: aspectSize.width, height: aspectSize.height))
        
        local.draw(in: CGRect(x: (size.width - aspectSize.width-10), y: 10, width: aspectSize.width, height: aspectSize.height))
        
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
    
    override func animateHeader() {
        
        if isStatusBarhiddenDuringAnimation == false {
            
            self.delegateCutsom?.visibleAnimateStatusBar()
            isStatusBarhiddenDuringAnimation = true
            UIView.animate(withDuration: 0.25) {
                
                self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5)
                self.layoutIfNeeded()
            }
            return
        }
        
        isStatusBarhiddenDuringAnimation = false
        self.delegateCutsom?.hidingAnimateStatusBar()
        UIView.animate(withDuration: 0.25) {
            
            self.headerTopConstraint?.constant = (UIApplication.shared.statusBarFrame.size.height+5)
            self.layoutIfNeeded()
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
}

