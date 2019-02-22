//
//  HostDashboardRootView.swift
//  Chatalyze
//
//  Created by Mansa on 24/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SDWebImage

class HostDashboardRootView: MySessionRootView {
    
    @IBOutlet var underLineLbl:UILabel?
    var fontSize:CGFloat = 16.0
    @IBOutlet private var settingButtonContainer:ButtonContainerCorners?
    @IBOutlet private var urlBorderView:ButtonContainerCorners?
    @IBOutlet var profileImage:UIImageView?
    @IBOutlet var userNameLbl:UILabel?
    @IBOutlet var userDescriptionLbl:UILabel?
    @IBOutlet var chatPupOne:UILabel?
    @IBOutlet var chatPupTwo:UILabel?

    override func viewDidLayout() {
        super.viewDidLayout()
      
        initializeFontSize()
        underLineLable()        
        paintChatPupText()
    }
    
    func paintChatPupText(){
        
        DispatchQueue.main.async {
            
            let textOne = "Looks like you don't have any"
            let textOneMutableAttr = textOne.toMutableAttributedString(font: "Open Sans", size: UIDevice.current.userInterfaceIdiom == .phone ? 13 : 17 , color: UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1), isUnderLine: false)
            
            let textTwo = "upcoming sessions."
            let textTwoAttr = textTwo.toMutableAttributedString(font: "Open Sans", size: UIDevice.current.userInterfaceIdiom == .phone ? 13 : 17, color: UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1), isUnderLine: false)
                        
            let textThree = " Let's create one!"
            let textThreeAttr = textThree.toMutableAttributedString(font: "Open Sans", size: UIDevice.current.userInterfaceIdiom == .phone ? 13 : 17, color: UIColor(red: 122.0/255.0, green: 202.0/255.0, blue: 250.0/255.0, alpha: 1), isUnderLine: false)
            
            textTwoAttr.append(textThreeAttr)
            
            self.chatPupOne?.attributedText = textOneMutableAttr
            self.chatPupTwo?.attributedText = textTwoAttr            
        }
    }
    
    override func paintNewUI(){
        
        settingButtonContainer?.layer.borderWidth = 0.5
        settingButtonContainer?.layer.borderColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1).cgColor
        
        urlBorderView?.layer.borderWidth = 0.5
        urlBorderView?.layer.borderColor = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1).cgColor
        
        profileImage?.layer.borderWidth = 1
        profileImage?.layer.borderColor = UIColor.white.cgColor
        profileImage?.layer.cornerRadius =   UIDevice.current.userInterfaceIdiom == .pad  ? 5 : 3
        profileImage?.layer.borderColor = UIColor.white.cgColor
        
        
        if let imageStr = SignedUserInfo.sharedInstance?.profileImage{
            
            profileImage?.sd_setImage(with: URL(string:imageStr), placeholderImage: UIImage(named:"user_placeholder"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
            })
        }
        
        userNameLbl?.text = SignedUserInfo.sharedInstance?.fullName ?? ""
        
        userDescriptionLbl?.text = SignedUserInfo.sharedInstance?.userDescription ?? ""
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        
        var testingText = "TEST MY PHONE"
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            testingText = "TEST MY IPAD"
        }

        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Poppins", size: fontSize)] as? [NSAttributedString.Key : Any]{
         
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            underLineLbl?.attributedText = underlineAttributedString
        }
    }
}
