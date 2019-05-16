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
    var eventInfo:EventScheduleInfo?
    @IBOutlet var shareView:UIView?
    @IBOutlet var confettiContainer:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confettiView = SAConfettiView(frame: self.confettiContainer?.bounds ?? CGRect.zero)
        confettiView.intensity = 0.95
        confettiView.startConfetti()
        self.view.addSubview(confettiView)
        DispatchQueue.main.asyncAfter(deadline: .now()+2.50) {
            confettiView.removeFromSuperview()
            confettiView.stopConfetti()
        }
        paintImageView()
        // Do any additional setup after loading the view.
    }
    
    func paintImageView(){
        
        self.memoryImageView?.image = memoryImage
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
