//
//  TestController.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    @IBOutlet var rotationalView:UIView?
    @IBOutlet var mainImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rotationalView?.rotate(angle: -10)
        // Do any additional setup after loading the view.
    }
    
    private func getSnapshot(view : UIView)->UIImage?{
        
        let bounds = view.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
        
    
    
//    func getSnapshot()->UIImage?{
////
////        guard let remoteView = remoteVideoView
////            else{
////                return nil
////        }
////
////        guard let localView = localVideoView
////            else{
////                return nil
////        }
////
////        guard let localImage = getSnapshot(view : localView)
////            else{
////                return nil
////        }
////
////        guard let remoteImage = getSnapshot(view : remoteView)
////            else{
////                return nil
////        }
////
////
////        guard let finalImage = mergeImage(remote: remoteImage, local: localImage)
////            else{
////                return nil
////        }
////
////        Log.echo(key: "remote", text: "final image > \(finalImage)")
////
////        let testView = MemoryFrame()
////        testView.bounds = self.view.bounds
////        testView.screenShotPic?.image = newSplash
////        return getSnapshot(view: testView)
////
//
//        // return finalImage
//    }
    
    
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
    
    
    @IBAction func showFirstImage(sender:UIImageView){
        
        let testView = MemoryFrame()
        testView.frame = CGRect(x: 0, y: 0, width: 1010, height: 160)
        testView.userPic?.image = UIImage(named: "newSplash")
        self.mainImageView?.image = getSnapshot(view: testView.stickerView ?? UIView())
    }
    
    @IBAction func showSecondFirstImage(sender:UIImageView){
        
        let testView = MemoryFrame()
        testView.frame = CGRect(x: 0, y: 0, width: 1562.5, height: 250)
        testView.userPic?.image = UIImage(named: "newSplash")
        guard let newImage =  getSnapshot(view: testView.stickerView ?? UIView()) else { return
            
        }
        
        guard let remoteImage = getSnapshot(view : self.view)
            else{
                return
        }
        
        guard let finalImage = mergeStampImage(remote: remoteImage, local: newImage)
            else {
                return
        }
        
        self.mainImageView?.image = finalImage
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func mergeStampImage(remote : UIImage, local : UIImage)->UIImage?{
        
        let size = remote.size
        let localSize = local.size
        
        let maxConstant = size.width > size.height ? size.width : size.height
        
        let localContainerSize = CGSize(width: 1010, height: 250)
        
        let aspectSize = AVMakeRect(aspectRatio: localSize, insideRect: CGRect(origin: CGPoint.zero, size: localContainerSize))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        remote.draw(in: CGRect(x: 0, y: size.height , width: size.width, height: size.height))
        
        let newPic = local.scaled(to: CGSize(width: 300, height: 250), scalingMode: .aspectFit)
        
        newPic.draw(in: CGRect(x: 0, y: 0, width: 300, height: 250))
        
        //local.draw(in: CGRect(x: (6), y: size.height-170, width: (size.width*(0.75)), height: 80))
        
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
    
    

}

extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}

// MARK: - Image Scaling.
extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}


// MARK: - UIView Extension -

extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
}
