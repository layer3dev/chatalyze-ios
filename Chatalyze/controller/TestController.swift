//
//  TestController.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class TestController: UIViewController {

    @IBOutlet var mainImageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    @IBAction func showImage(sender:UIImageView){
        
        let testView = MemoryFrame()
        testView.frame = self.mainImageView?.frame ?? self.view.frame
        testView.screenShotPic?.image = UIImage(named: "newSplash")
        self.mainImageView?.image = getSnapshot(view: testView)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}
