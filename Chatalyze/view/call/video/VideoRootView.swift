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
    
    private var hangupListener : (()->())?
    private var loadListener : (()->())?
    
    
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
        paintInterface()
        addToogleGesture()
    }
    
    private func initializeVariable(){
        
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
        
        guard let url = info?.eventBannerUrl
            else{
                self.getPostImageSnapshot(info: info, eventLogo: nil, completion: completion)
                return
        }
        CacheImageLoader.sharedInstance.loadImage(url, token: { () -> (Int) in
            return 0
        }) { (success, image) in
            self.getPostImageSnapshot(info: info, eventLogo: image, completion: completion)
            return
        }
    }
    
 
    func getPostImageSnapshot(info:EventInfo?,eventLogo:UIImage?, completion: @escaping ((_ image:UIImage?)->())){
        
        Log.echo(key: "VideoRootView", text: "call get Video Frame")
            
        getVideoFrame(listener: {[weak self] (local, remote) in
            Log.echo(key: "VideoRootView", text: "received BOTH frame")
            self?.renderScreenshot(localFrame: local, remoteFrame: remote, eventLogo : eventLogo, info: info, completion: completion)
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
    
    

   private func renderScreenshot(localFrame : UIImage?, remoteFrame : UIImage?, eventLogo : UIImage?, info:EventInfo?,completion:((_ image:UIImage?)->())){
       
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
       testView.screenShotPic?.image = finalImage
       testView.memoryStickerView?.renderImage(image: eventLogo)
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
        let height = CGFloat(1030)
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
            
            let maxWidth = min(hostPicture.size.width, userPicture.size.width)
            
            var cropHostPic : UIImage?
            var cropUserPic : UIImage?
            
            
            if hostPicture.size.width < hostPicture.size.height{
                cropHostPic = resizeImage(image: hostPicture, targetSize: CGSize(width: 300, height: 600))
                Log.echo(key: "dhimu", text: "host picture is portrait")
            }else{
                
                cropHostPic = hostPicture.crop(to: CGSize(width: 500, height: 700))
                Log.echo(key: "dhimu", text: "host picture is landscape")
            }
            
            if userPicture.size.width > userPicture.size.height{
                cropUserPic = userPicture.crop(to: CGSize(width: 500, height: 700))
                Log.echo(key: "dhimu", text: "user picture is landscape")
            }else{
                cropUserPic = resizeImage(image: userPicture, targetSize: CGSize(width: 300, height: 600))
                Log.echo(key: "dhimu", text: "user picture is portarit")
            }
           
            
            let aspactHost = imageWithImage(sourceImage: cropHostPic!, scaledToWidth: 200)
            let aspactLocal = imageWithImage(sourceImage: cropUserPic!, scaledToWidth: 200)
            
            let finalWidth = aspactHost.size.width + aspactLocal.size.width
            let finalHeight = aspactLocal.size.height < aspactLocal.size.height ? aspactLocal.size.height : aspactHost.size.height
            
            
    

            let finalFrame = CGSize(width: finalWidth, height: finalHeight)

            UIGraphicsBeginImageContextWithOptions(finalFrame, false, 0.0)
            
            aspactHost.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: aspactHost.size))
            aspactLocal.draw(in: CGRect(origin: CGPoint(x: ((aspactHost.size.width)) + 5, y: 0), size: aspactHost.size))
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return finalImage
        }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: targetSize.width, height: targetSize.height)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth

        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor

        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

extension UIImage
{

    
    func imageScaledToFit(to size: CGSize) -> UIImage? {
        let scaledRect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
           UIGraphicsBeginImageContextWithOptions(size, false, 0)
           draw(in: scaledRect)
           let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return scaledImage
       }
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
