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
    
    var urlString:String?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintView()
        setUpGestureOnLabel()
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
        _ = influencer?.fullName ?? ""
        
    
        //tipLabel?.text = "Would you like to say thanks to \(influencerName) by leaving a tip?"
        //tipLabel?.text = self.scheduleInfo?.tipText
        setDonationText()
        
        
        //tipLabel?.addImage(imageName: "whiteInfoIcon", afterLabel: true)
        guard let image = influencer?.profileImage
            else{
                return
        }
        
        profileImage?.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"user_placeholder"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
        })
    }
    
    
    func setDonationText(){
        
        DispatchQueue.main.async {
            
            guard let tipText = self.scheduleInfo?.tipText else{
                return
            }
            
            let tipTextCollection = tipText.components(separatedBy: " ")
            let requiredMutableString = NSMutableAttributedString()
            var fontSize = 16
            if UIDevice.current.userInterfaceIdiom == .pad{
                fontSize = 20
            }
            for info in tipTextCollection{
                
                if info.contains("www.") || info.contains("http") || info.contains("https"){
                    
                    let reqText = info + " "
                    let reqAtr = reqText.toAttributedStringLink(size: fontSize, color: UIColor(red: 97.0/255.0, green: 136.0/255.0, blue: 232.0/255.0, alpha: 1), isUnderLine: true)
                    requiredMutableString.append(reqAtr)
                    self.urlString = info
                    continue
                    
                }
                let reqText = info + " "
                let reqAtr = reqText.toAttributedString(size: fontSize, color: UIColor.white, isUnderLine: false)
                requiredMutableString.append(reqAtr)
            }
            
            self.tipLabel?.attributedText = requiredMutableString
            self.tipLabel?.isUserInteractionEnabled = true
        }
    }
    
    
    func setUpGestureOnLabel(){
          
           let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
           self.tipLabel?.addGestureRecognizer(tap)
           self.tipLabel?.isUserInteractionEnabled = true
       }
       
       @objc func tapLabel(tap: UITapGestureRecognizer) {
           
        guard var urlstr = urlString else{
            return
        }
        
        if !urlstr.contains("https") || !urlstr.contains("http"){
            urlstr = "https://"+urlstr
        }
        
        if #available(iOS 10.0, *) {
            
            guard let url = URL(string: urlstr) else{
                return
            }
            UIApplication.shared.open(url, options: [:])
            
            print("opening the url \(url)")
        } else {
            // Fallback on earlier versions
        }
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

