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
        let height = CGFloat(1130)
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
            
//            let size = hostPicture.size
//            let localSize = userPicture.size
            
            let cropHost = cropImageToSquare(image: hostPicture)
            let size = cropHost!.size
            Log.echo(key: "atul-->HostImg", text: "host img sixze\(String(describing: cropHost!.size))")
            
            let cropLocal = cropImageToSquare(image: userPicture)
            let localSize = cropLocal!.size
            Log.echo(key: "atul-->LocalImg", text: "Local img sixze\(String(describing: cropLocal!.size))")
            
            let maxConstant = size.width > size.height ? size.width : size.height
            
            let localContainerSize = CGSize(width: maxConstant / 2, height: maxConstant / 2)
            
            let aspectSize = AVMakeRect(aspectRatio: size, insideRect: CGRect(origin: CGPoint.zero, size: localContainerSize))
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            cropHost?.draw(in: CGRect(x: 0, y: 0, width: aspectSize.width, height: size.height))
        
            
            userPicture.draw(in: CGRect(x: (size.width / 2 + 5), y: 0, width: size.width / 2 , height: size.height))
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return finalImage
        }
    
    
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width

        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }

        let size = CGSize(width: imageWidth, height: imageHeight)

        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)

        let x = (refWidth - size.width) / 2
        let y = CGFloat(0)

        let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }

       return nil
    }
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
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

