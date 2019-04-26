
//
//  ScheduleSessionDonationRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ScheduleSessionDonationRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class ScheduleSessionDonationRootView: ExtendedRootView {
    
    var delegate:ScheduleSessionDonationRootViewDelegate?
    
    enum DobationStatus:Int{
        
        case yes = 0
        case no = 1
        case none = 2
    }
    
    @IBOutlet private var isDonationYesBtn:UIButton?
    @IBOutlet private var isDonationNoBtn:UIButton?
    @IBOutlet private var socialErrorLbl:UILabel?
    
    private var isDonationAllowed:DobationStatus = .none
    @IBOutlet private var nextView:UIView?
    @IBOutlet private var chatPupView:ButtonContainerCorners?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintLayers()
    }
    
    func resetSocialSelection(){
        
        isDonationYesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        isDonationNoBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        paintLayers()
    }    
    
    func paintLayers() {
        
        self.nextView?.layer.masksToBounds = true
        self.nextView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.nextView?.layer.borderWidth = 1
        self.nextView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
        
        
        self.chatPupView?.layer.masksToBounds = true
        self.chatPupView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.chatPupView?.layer.borderWidth = 1
        self.chatPupView?.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1).cgColor
    }
    
    //MARK:- Button Action
    @IBAction func nextButtonAction(sender:UIButton){
        
        if !validateFields(){
            return
        }
        updateParam()
        delegate?.goToNextScreen()
    }
    
    @IBAction func isAllowedForSelfieAction(sender:UIButton){
        
        if sender.tag == 0 {
            
            resetSocialSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.isDonationAllowed = .yes
        }
        else if sender.tag == 1{
            
            resetSocialSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.isDonationAllowed = .no
        }
        let _ = validateSocialSharing()
    }
    
    func resetErrorStatus(){
        
        socialErrorLbl?.text = ""
    }
    
    func validateFields()->Bool{
        
        let socialValidation = validateSocialSharing()
        return socialValidation
    }
    
    fileprivate func validateSocialSharing()->Bool{
        
        if(isDonationAllowed == .none){
            
            socialErrorLbl?.text = "Please specify whether you want to enable tip after their chat."
            return false
        }
        socialErrorLbl?.text = ""
        return true
    }
    
    
    func updateParam(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        info.tipEnabled = self.isDonationAllowed == .yes ? true:false
    }
}
