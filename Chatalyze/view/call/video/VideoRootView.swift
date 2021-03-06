//
//  VideoRootView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit
import SDWebImage

class VideoRootView: ExtendedView {
    
    @IBOutlet var callInfoContainer : CallInfoContainerView?
    
    var testView = MemoryFrame()
    var defaultImage : UIImage?
    var selfieFrameImage : UIImage?
    var eventBannerImg : UIImage?
    
    @IBOutlet var headerTopConstraint:NSLayoutConstraint?
    var isStatusBarhiddenDuringAnimation = true
    @IBOutlet var headerView:UIView?
    var delegateCutsom:VideoViewStatusBarAnimationInterface?
    
    @IBOutlet var actionContainer : VideoActionContainer?
    @IBOutlet var localVideoView : LocalHostVideoView?
    
    @IBOutlet var remoteVideoContainerView :  RemoteHostContainerView?
    
    var remoteVideoView : RemoteVideoView?{
        get{
            return remoteVideoContainerView?.remoteVideoView
        }
    }
    
    var isLogoRemeovedForOrganizationHost :Bool?
    var isInternational : Bool?
    
    private var hangupListener : (()->())?
    private var loadListener : (()->())?
    private var defaultImgListner : (()->())?
    
    
    /*
     // On@objc ly override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    func confirmViewLoad(listener : (()->())?){
        self.loadListener = listener
        
        if(isLoaded){
            listener?()
            return
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
        self.loadListener?()
    }
    
    private func initialization(){
        
        initializeVariable()
        getDefaultImage()
        paintInterface()
        addToogleGesture()
        
    }
    
    private func initializeVariable(){
        
    }
    
    private func getDefaultImage(){
        let roomId = UserDefaults.standard.string(forKey: "room_id") ?? ""
        self.getDefulatImage(roomId: roomId)
    }
    
    private func paintInterface(){
        self.headerTopConstraint?.constant = UIApplication.shared.statusBarFrame.size.height + 5.0
    }
    
    func addToogleGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleContainer(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
     func getDefulatImage(roomId : String){
        RequestDefaultImage().fetchInfo(id: roomId) { (success, response) in
            if success{
                
                if let info = response{
                    let defaulImage = info["user"]["defaultImage"]["url"].stringValue
                    self.isInternational = info["user"]["organization"]["selfieDateFormat"].boolValue
                    let isOrhanizationHost = info["user"]["organization"]["removeLogo"].boolValue
                    self.isLogoRemeovedForOrganizationHost = isOrhanizationHost
                    Log.echo(key: "isLogoRemeovedForOrganizationHost", text: "\(self.isLogoRemeovedForOrganizationHost)")
                    
                    Log.echo(key: "abhi", text: "\(isOrhanizationHost)")
                    SDWebImageDownloader().downloadImage(with: URL(string: defaulImage), options: SDWebImageDownloaderOptions.highPriority, progress: nil) { (image, imageData, error, result) in
                        guard let img = image else {
                            // No image handle this error
                            Log.echo(key: "vijayDefault", text: "no defaultImage Found")
                            return
                        }
                        self.defaultImage = img
                        Log.echo(key: "vijayDefault", text: "defaultImage Found")
                    }
                }
            }
        }
    }
    
    func hangupListener(listener : (()->())?){
        
        self.hangupListener = listener
    }
    
    @objc func toggleContainer(gesture: UITapGestureRecognizer){
        
        actionContainer?.toggleContainer()
        animateHeader()
    }
    
    
    func animateHeader(){
        //TO be overridden in order to hide and show the topmost Header
    }
    
    func animateSignatureAccessoryView(){
        //TO be overridden in order to hide and show the signature accessory view.
    }
    
    //***************
    
    private func getSnapshot(view : UIView)->UIImage?{
        
        let bounds = view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        Log.echo(key: "getSnapshot", text: "image -> \(image)")
        return image
    }
       
    
    func getSnapshot(info:EventInfo?,completion:@escaping ((_ image:UIImage?)->())){
        
        //        guard let url = info?.eventBannerUrl
        //            else{
        //                self.getPostImageSnapshot(info: info, eventLogo: nil, completion: completion)
        //                return
        //        }
        //        CacheImageLoader.sharedInstance.loadImage(url, token: { () -> (Int) in
        //            return 0
        //        }) { (success, image) in
        //            self.getPostImageSnapshot(info: info, eventLogo: image, completion: completion)
        //            return
        //        }
        
        
        if let eventInfo = info{
            if let bannerUrl = eventInfo.eventBannerUrl{
                Log.echo(key: "getSnapshot", text: " got bannerUrl, will check if i have frame URL as well")
                CacheImageLoader.sharedInstance.loadImage(bannerUrl, token: {()->(Int) in
                    return 0
                }) { success, bannerImg in
                    
                    // check if it contains selfie frame as well
                    if let frameUrl = eventInfo.selfieFrameURL{
                        Log.echo(key: "getSnapshot", text: " got frame URL as well")

                        CacheImageLoader.sharedInstance.loadImage(frameUrl, token: {()->(Int) in return 0}) { success, frameImg in
                            self.getPostImageSnapshot(info: info, eventLogo: bannerImg, frameImg: frameImg , completion: completion)
                            return
                        }
                    }else{
                        self.getPostImageSnapshot(info: info, eventLogo: bannerImg, frameImg: nil , completion: completion)
                        return
                    }
                }
            }else if let frameUrl = eventInfo.selfieFrameURL{
                Log.echo(key: "getSnapshot", text: "only got frame URL")
                CacheImageLoader.sharedInstance.loadImage(frameUrl, token: {()->(Int) in return 0}) { success, frameImg in
                    self.getPostImageSnapshot(info: info, eventLogo: nil, frameImg: frameImg , completion: completion)
                    return
                }
            }else{
                Log.echo(key: "getSnapshot", text: "No URL found")
                self.getPostImageSnapshot(info: info, eventLogo: nil, frameImg: nil , completion: completion)
                return
            }
        }
        
    }
    
 
    func getPostImageSnapshot(info:EventInfo?,eventLogo:UIImage?,frameImg : UIImage?, completion: @escaping ((_ image:UIImage?)->())){
        
        Log.echo(key: "VideoRootView", text: "call get Video Frame")
            
        getVideoFrame(listener: {[weak self] (local, remote) in
            Log.echo(key: "VideoRootView", text: "received BOTH frame")
            self?.renderScreenshot(localFrame: local, frameImg: frameImg, remoteFrame: remote, eventLogo : eventLogo, info: info, completion: completion)
        })
    }
    
    private func getVideoFrame(listener : ((_ localFrame : UIImage?, _ remoteFrame : UIImage?) -> ())?){
        
        Log.echo(key: "VideoRootView", text: "getVideoFrame")
        var localFrame : UIImage? = nil
        var remoteFrame : UIImage? = nil
        var localListener = listener
        
        localVideoView?.getFrame(listener: { (frame) in
            
            Log.echo(key: "VideoRootView", text: "localVideoView frame received")
            guard let frame = frame
                else{
                    localListener?(nil, remoteFrame)
                    localListener = nil
                    return
            }
            localFrame = frame
            if(remoteFrame == nil){
                return
            }
            
            localListener?(localFrame, remoteFrame)
            
            localListener = nil
    
        })
        
        remoteVideoView?.getFrame(listener: { (frame) in
            Log.echo(key: "VideoRootView", text: "remoteVideoView frame received")

            guard let frame = frame
                else{
                    localListener?(nil, localFrame)
                    localListener = nil
                    return
            }
            remoteFrame = frame
            if(localFrame == nil){
                return
            }
            localListener?(localFrame, remoteFrame)
            localListener = nil
            
        })
    }
        

    private func frameSize(childSize : CGSize) -> CGSize{
        //Log.echo(key: TAG, text: "childSize -> \(childSize)")
        let constant = CGFloat(600)
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
    
    

    private func renderScreenshot(localFrame : UIImage?, frameImg : UIImage?, remoteFrame : UIImage?, eventLogo : UIImage?, info:EventInfo?,completion:((_ image:UIImage?)->())){
       
       testView = MemoryFrame()
   
    
       
       guard let localImage = localFrame, let remoteImage = remoteFrame
           else{
               completion(nil)
               return
       }
       
       guard let finalImage = mergePicture(local: localImage, remote: remoteImage)
           else{
               completion(nil)
               return
       }
           
       let isPortraitInSize = isPortrait(size: finalImage.size)
       
       Log.echo(key: "yud", text: "is image is portrait \(String(describing: isPortraitInSize))")
       
       testView.isPortraitInSize = isPortraitInSize
       testView.frame.size = extractFrame(image: finalImage)
    let size = extractFrame(image: finalImage)
    Log.echo(key: "vijay_FRR", text: "\(size)")
    
       testView.screenShotPic?.image = finalImage
        testView.selfieFrameImg = frameImg
        if let isInternational = self.isInternational {
            testView.memoryStickerView?.isInternational = isInternational
        }
       testView.memoryStickerView?.renderImage(image: eventLogo)
      testView.isLogoRemeovedForOrganizationHost = isLogoRemeovedForOrganizationHost
    Log.echo(key: "isLogoRemeovedForOrganizationHost", text: "\(isLogoRemeovedForOrganizationHost)")
       testView.userInfo = info
       
       completion(getSnapshot(view: testView))
   }
    
    private func extractFrame(image : UIImage) -> CGSize{
        let isPortraitSize = isPortrait(size: image.size)
        if(isPortraitSize){
            return extractPortraitFrame(image: image)
        }
        return extractLandscapeFrame(image: image)
    }
    
    private func extractPortraitFrame(image : UIImage) -> CGSize{
        let height = CGFloat(600)
        let width = (image.size.width / image.size.height) * height
        return CGSize(width: width, height: height)
    }
    
    private func extractLandscapeFrame(image : UIImage) -> CGSize{
        let width = CGFloat(1024)
        let height = (width / image.size.width) * image.size.height
        return CGSize(width: width, height: height)
    }
    
    func mergePicture(local : UIImage, remote : UIImage) -> UIImage?{
        return nil
    }
    
    //Developer Y
    func isPortrait(size:CGSize)->Bool{
        
        print("size of the frame is \(size)")
        
        let minimumSize = size
        let mW = minimumSize.width
        let mH = minimumSize.height
        
        if( mH >= mW ) {
            return true
        }
        return false
    }
        
    
        func mergeImage(hostPicture : UIImage, userPicture : UIImage)->UIImage?{
            
            if let userType = SignedUserInfo.sharedInstance?.role {
                
                if userType == .analyst{
                    if let defaultImg = self.defaultImage {
                        return defaultImg
                    }else{
                        Log.echo(key: "vijayDefault", text: "no defaultImage Found")
                    }
                }
                
            }
        
            var cropHostPic = UIImage()
            var cropUserPic = UIImage()
            var aspactHost : UIImage?
            var aspactLocal : UIImage?
            
            
            if hostPicture.size.width < hostPicture.size.height{
                cropHostPic = hostPicture
                
                Log.echo(key: "dhimu", text: "host picture is portrait")
            }else{
                
                cropHostPic = hostPicture.crop(to: CGSize(width: 650, height: 1020))
                Log.echo(key: "dhimu", text: "host picture is landscape")
            }
            
            if userPicture.size.width > userPicture.size.height{
                cropUserPic = userPicture.crop(to: CGSize(width: 650, height: 1020))
                Log.echo(key: "dhimu", text: "user picture is landscape")
            }else{
                cropUserPic = userPicture
                Log.echo(key: "dhimu", text: "user picture is portarit")
            }
           
            
           
            let ipadSize = CGSize(width: 200, height: 400)
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                 aspactHost = cropHostPic.sd_resizedImage(with: ipadSize, scaleMode: .aspectFill)
                 aspactLocal =  cropUserPic.sd_resizedImage(with: ipadSize, scaleMode: .aspectFill)
            }else{
                 aspactHost = cropHostPic.sd_resizedImage(with: ipadSize, scaleMode: .aspectFill)
                 aspactLocal =  cropUserPic.sd_resizedImage(with: ipadSize, scaleMode: .aspectFill)
            }
           
            
            let finalWidth = (aspactHost?.size.width)! * 2
            let finalHeight = (aspactHost?.size.height)! > aspactLocal!.size.height ? aspactHost!.size.height : aspactLocal!.size.height
            

            let finalFrame = CGSize(width: finalWidth, height: finalHeight)

            UIGraphicsBeginImageContextWithOptions(finalFrame, false, 0.0)
            
            aspactHost!.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: finalWidth / 2, height: finalHeight)))
            aspactLocal!.draw(in: CGRect(origin: CGPoint(x: ((aspactHost!.size.width)) + 5, y: 0), size: CGSize(width: finalWidth / 2, height: finalHeight)))
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return finalImage
        }

}


extension VideoRootView:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.shouldTapAllow(touch: touch)
    }
    
    @objc func shouldTapAllow(touch: UITouch)->Bool{
        //To be overridden
        return true
    }
}

extension UIImage{
    func crop(to:CGSize) -> UIImage {

        guard let cgimage = self.cgImage else { return self }

        let contextImage: UIImage = UIImage(cgImage: cgimage)

        guard let newCgImage = contextImage.cgImage else { return self }

        let contextSize: CGSize = contextImage.size

        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height

        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height

        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

        // Create bitmap image from context using the rect
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized?.fixOrientation() ?? self
      
    }

    

    // Extension to fix orientation of an UIImage without EXIF
        func fixOrientation() -> UIImage {

            guard let cgImage = cgImage else { return self }

            if imageOrientation == .up { return self }

            var transform = CGAffineTransform.identity

            switch imageOrientation {

            case .down, .downMirrored:
                transform = transform.translatedBy(x: size.width, y: size.height)
                transform = transform.rotated(by: CGFloat(M_PI))

            case .left, .leftMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.rotated(by: CGFloat(M_PI_2))

            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: size.height)
                transform = transform.rotated(by: CGFloat(-M_PI_2))

            case .up, .upMirrored:
                break
            }

            switch imageOrientation {

            case .upMirrored, .downMirrored:
                transform.translatedBy(x: size.width, y: 0)
                transform.scaledBy(x: -1, y: 1)

            case .leftMirrored, .rightMirrored:
                transform.translatedBy(x: size.height, y: 0)
                transform.scaledBy(x: -1, y: 1)

            case .up, .down, .left, .right:
                break
            }

            if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {

                ctx.concatenate(transform)

                switch imageOrientation {

                case .left, .leftMirrored, .right, .rightMirrored:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))

                default:
                    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }

                if let finalImage = ctx.makeImage() {
                    return (UIImage(cgImage: finalImage))
                }
            }

            // something failed -- return original
            return self
        }

}


extension UIImage {
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

