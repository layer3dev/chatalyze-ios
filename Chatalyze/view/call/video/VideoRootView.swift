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
        
        guard let localView = self.localVideoView else{
            print("missing local video ")
            completion(nil)
            return
        }
        
        guard let remoteView = self.remoteVideoView else{
            print("missing remote video ")

            completion(nil)
            return
        }
        
        guard let localViewImage = self.getSnapshot(view : localView) else{
            print("missing local image ")

            completion(nil)
            return
        }
        
        guard let remoteViewImage = self.getSnapshot(view : remoteView) else{
            print("missing remote image ")

            completion(nil)
            return 
        }
        
        self.renderScreenshot(localFrame: localViewImage, remoteFrame: remoteViewImage, eventLogo : eventLogo, info: info, completion: completion)
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
        print("rendering success full")
        
        guard let localImage = localFrame, let remoteImage = remoteFrame
            else{
                print("rendering missing local image and remote image ")
                completion(nil)
                return
        }
        
        //mergeImage(hostPicture: localImage, userPicture: remoteImage)
        guard let finalImage = mergeImage(hostPicture: remoteImage, userPicture: localImage)
            else{
                print("rendering mergeIMAGE missing")
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
        testView.memoryStickerView?.renderImage(image: eventLogo)
        completion(getSnapshot(view: testView))
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
        
    
    func mergeImage(hostPicture : UIImage, userPicture : UIImage)->UIImage?{
        
        let size = hostPicture.size
        let localSize = userPicture.size
        
        let maxConstant = size.width > size.height ? size.width : size.height
        
        let localContainerSize = CGSize(width: maxConstant/4, height: maxConstant/4)
        
        let aspectSize = AVMakeRect(aspectRatio: localSize, insideRect: CGRect(origin: CGPoint.zero, size: localContainerSize))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        hostPicture.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //local.draw(in: CGRect(x: (size.width - aspectSize.width+20), y: (size.height - aspectSize.height), width: aspectSize.width, height: aspectSize.height))
        
        userPicture.draw(in: CGRect(x: (size.width - aspectSize.width-10), y: 10, width: aspectSize.width, height: aspectSize.height))
        
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

