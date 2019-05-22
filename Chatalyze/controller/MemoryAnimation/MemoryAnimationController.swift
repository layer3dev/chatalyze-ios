//
//  MemoryAnimationController.swift
//  Chatalyze
//
//  Created by mansa infotech on 13/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SAConfettiView

class MemoryAnimationController: InterfaceExtendedController {
    
    var memoryImage:UIImage?
    @IBOutlet var memoryImageView:UIImageView?
    @IBOutlet var memoryLandscapeImageView:UIImageView?

    var eventInfo:EventScheduleInfo?
    @IBOutlet var shareView:UIView?
    @IBOutlet var confettiContainer:UIView?
    
    @IBOutlet var heightOfLayerImage:NSLayoutConstraint?
    @IBOutlet var portraitView:UIView?
    @IBOutlet var landscapeView:UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.memoryImage{
            if isPortrait(size: image.size) ?? true{
                
                portraitView?.isHidden = false
                landscapeView?.isHidden = true
            }else{
                
                landscapeView?.isHidden = false
                portraitView?.isHidden = true
            }
        }
        
        let confettiView = SAConfettiView(frame: self.confettiContainer?.bounds ?? CGRect.zero)
        confettiView.intensity = 0.95
        confettiView.startConfetti()
        self.view.addSubview(confettiView)
        DispatchQueue.main.asyncAfter(deadline: .now()+2.50) {
            UIView.animate(withDuration: 1, animations: {
                confettiView.alpha = 0
            }, completion: { (success) in
                confettiView.removeFromSuperview()
                confettiView.stopConfetti()
            })            
        }
        corniiRadiusToMemoryImage()
        //paintImageView()
        // Do any additional setup after loading the view.
    }
    
    
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
    
    func paintImageView(){
        
        self.memoryImageView?.image = memoryImage
        self.memoryLandscapeImageView?.image = memoryImage
    }
    
    func corniiRadiusToMemoryImage(){
        
        self.memoryImageView?.layer.cornerRadius = 4
        self.memoryLandscapeImageView?.layer.cornerRadius = 4
        
        self.memoryImageView?.layer.masksToBounds = true
        self.memoryLandscapeImageView?.layer.masksToBounds = true
    }
    
    @IBAction func jumpToScroller(){
        
        if self.memoryImage == nil {
            return
        }        
        guard let controller = AchievementImageController.instance() else{
            return
        }
        controller.showingImage = self.memoryImage
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: {
        })
    }
    
    
    @IBAction func ShareAction(sender:UIButton){
        
        guard let memoryImage = self.memoryImage else{
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            avc.popoverPresentationController?.sourceView = self.view
            avc.popoverPresentationController?.sourceRect = sender.frame
            self.present(avc, animated: true, completion: nil)
            
        }else{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func dismiss(sender:UIButton?){
        
        Log.echo(key: "yud", text: "Exit is calling")
        
        
        guard let controller = ReviewController.instance() else {
            return
        }
        controller.eventInfo = self.eventInfo
        self.present(controller, animated: true, completion: {
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    class func instance()->MemoryAnimationController?{
        
        let storyboard = UIStoryboard(name: "MemoryAnimation", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemoryAnimation") as? MemoryAnimationController
        return controller
    }

}
