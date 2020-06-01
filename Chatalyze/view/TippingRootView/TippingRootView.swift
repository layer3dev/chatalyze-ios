//
//  TippingRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class TippingRootView: ExtendedView {
    
    @IBOutlet private var dollorOneView:UIView?
    @IBOutlet private var dollorTwoView:UIView?
    @IBOutlet private var dollorThreeView:UIView?
    @IBOutlet private var customTipView:UIView?
    @IBOutlet private var noTipView:UIView?
    @IBOutlet private var tipLabel:UILabel?
    @IBOutlet private var profileImage:UIImageView?
    
    private var scheduleInfo : EventScheduleInfo?
    var controller:TippingConfirmationController?
    
    var isAlertShowing = false
    @IBOutlet var alertCustomView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintView()
    }
    
    func paintView(){
        
        alertCustomView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 8:5
       
        profileImage?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 55:45
        profileImage?.layer.masksToBounds = true
        
        dollorOneView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorOneView?.layer.masksToBounds = true
        
        dollorTwoView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorTwoView?.layer.masksToBounds = true

        dollorThreeView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        dollorThreeView?.layer.masksToBounds = true

        customTipView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        customTipView?.layer.masksToBounds = true
        
        noTipView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 35:25
        noTipView?.layer.masksToBounds = true
    }
    
    func fillInfo(scheduleInfo : EventScheduleInfo?){
        self.scheduleInfo = scheduleInfo
        
        guard let scheduleInfo = scheduleInfo
            else{
                return
        }
        
        let influencer = scheduleInfo.user
        let influencerName = influencer?.fullName ?? ""
        
    
        //tipLabel?.text = "Would you like to say thanks to \(influencerName) by leaving a tip?"
        tipLabel?.text = self.scheduleInfo?.tipText
    
        //tipLabel?.addImage(imageName: "whiteInfoIcon", afterLabel: true)
        guard let image = influencer?.profileImage
            else{
                return
        }
        
        profileImage?.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"user_placeholder"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
        })
    }
    
    @IBAction func infoAlert(sender:UIButton){
        
//        if isAlertShowing{
//
//            UIView.animate(withDuration: 0.35) {
//
//                self.alertCustomView?.alpha = 0
//            }
//            self.layoutIfNeeded()
//            isAlertShowing = false
//            return
//        }
//
//        UIView.animate(withDuration: 0.35) {
//
//            self.alertCustomView?.alpha = 1
//        }
//        self.layoutIfNeeded()
//        isAlertShowing = true
//        return
    }
}

