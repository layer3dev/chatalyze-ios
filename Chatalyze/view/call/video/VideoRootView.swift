//
//  VideoRootView.swift
//  Rumpur
//
//  Created by Sumant Handa on 13/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class VideoRootView: ExtendedView {
   
    let testView = MemoryFrame()
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
    
    var callOverlayView : CallOverlayView?

    /*
    // Only override draw() if you perform custom drawing.
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
        
        callOverlayView = CallOverlayView()
    }
    
    private func paintInterface(){
        //paintOverlay()
        //self.actionContainer?.isHidden = true
    }
    
    private func paintOverlay(){
        
        guard let callOverlayView = self.callOverlayView
            else{
                return
        }
        self.addSubview(callOverlayView)
        self.addConstraints(childView: callOverlayView)
        callOverlayView.isHidden = true
        callOverlayView.hangupListener {
            self.hangupListener?()
        }
    }
    
    func switchToCallRequest(){
        
        callOverlayView?.isHidden = false
        actionContainer?.isHidden = true
    }
    
    func switchToCallAccept(){
        
        callOverlayView?.isHidden = true
        actionContainer?.isHidden = false
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
    
    func mergePicture(local : UIImage, remote : UIImage) -> UIImage?{
        return nil
    }
}


extension VideoRootView{
    func getPostImageSnapshot(info:EventInfo?,hostImage:UIImage?,  completion: @escaping ((_ image:UIImage?)->())){
        
        Log.echo(key: "VideoRootView", text: "call get Video Frame")
            
        getVideoFrame(listener: {[weak self] (local, remote) in
            Log.echo(key: "VideoRootView", text: "received BOTH frame")
            self?.renderScreenshot(localFrame: local, remoteFrame: remote, info: info, completion: completion)
        })
        
           
           // return finalImage
       }
    
    
    private func renderScreenshot(localFrame : UIImage?, remoteFrame : UIImage?, info:EventInfo?,completion:((_ image:UIImage?)->())){
        
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
        if isPortraitInSize ?? true{
            testView.frame.size = CGSize(width: 636, height: 1130)
        }else{
            testView.frame.size = CGSize(width: 1024, height: 576)
        }
        testView.screenShotPic?.image = finalImage
        testView.userPic?.image = nil
        testView.name?.text = ("Chat with ") + (info?.user?.firstName ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let comingDate = info?.startDate ?? Date()
        let requireDate = dateFormatter.string(from: comingDate)
        testView.date?.text = "\(requireDate)"
        completion(getSnapshot(view: testView))
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
       
    
      
       
       
       private func getSnapshot(view : UIView)->UIImage?{
           
           let bounds = view.bounds
           UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
           view.drawHierarchy(in: bounds, afterScreenUpdates: true)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
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

