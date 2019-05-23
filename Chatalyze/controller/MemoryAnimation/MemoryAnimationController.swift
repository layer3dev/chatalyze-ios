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
    
    @IBOutlet var portraitShadowView:UIView?
    @IBOutlet var landscapeShadowView:UIView?
    
    
    @IBOutlet var rotationalView:UIView?
    @IBOutlet var landscapeRotationalView:UIView?

    var memoryImage:UIImage?
    @IBOutlet var memoryImageView:UIImageView?
    @IBOutlet var memoryLandscapeImageView:UIImageView?

    var eventInfo:EventScheduleInfo?
    @IBOutlet var shareView:UIView?
    @IBOutlet var confettiContainer:UIView?
    
    @IBOutlet var heightOfLayerImage:NSLayoutConstraint?
    @IBOutlet var portraitView:UIView?
    @IBOutlet var landscapeView:UIView?

    
    @IBOutlet var memoryLandscapeHeight:NSLayoutConstraint?
    @IBOutlet var memoryLandscapeWidth:NSLayoutConstraint?
    
    @IBOutlet var memoryPortraitHeight:NSLayoutConstraint?
    @IBOutlet var memoryPortraitWidth:NSLayoutConstraint?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let newRect = self.memoryLandscapeImageView?.contentClippingRect
        self.memoryLandscapeHeight?.constant = newRect?.height ?? 0.0
        self.memoryLandscapeWidth?.constant = newRect?.width ?? 0.0
        
        let newRectP = self.memoryImageView?.contentClippingRect
        self.memoryPortraitHeight?.constant = newRectP?.height ?? 0.0
        self.memoryPortraitWidth?.constant = newRectP?.width ?? 0.0
        
        self.landscapeShadowView?.dropShadow(color: UIColor.darkGray, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 18:15, scale: true,layerCornerRadius:UIDevice.current.userInterfaceIdiom == .pad ? 5:3)
        
        self.portraitShadowView?.dropShadow(color: UIColor.darkGray, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 18:15, scale: true,layerCornerRadius:UIDevice.current.userInterfaceIdiom == .pad ? 5:3)
        
        corniiRadiusToMemoryImage()
        Log.echo(key: "yu)d", text: "clipiping recxt is \(self.memoryImageView?.contentClippingRect)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //paintImageView()
        self.rotationalView?.rotate(angle: -5)
        self.landscapeRotationalView?.rotate(angle: -5)

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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

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

extension UIImageView {
    
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
