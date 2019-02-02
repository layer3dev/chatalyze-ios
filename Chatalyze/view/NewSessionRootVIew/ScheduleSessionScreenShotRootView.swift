//
//  ScheduleSessionScreenShotRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 01/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionScreenShotRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class ScheduleSessionScreenShotRootView: ExtendedRootView {
    
    var delegate:ScheduleSessionScreenShotRootViewDelegate?
    
    enum isSelfieAllowed:Int{
        
        case yes = 0
        case no = 1
        case none = 2
    }
    
    @IBOutlet private var isSocialYesBtn:UIButton?
    @IBOutlet private var isSocialNoBtn:UIButton?
    @IBOutlet private var socialErrorLbl:UILabel?
    
    private var isSocialSelfieAllowed:isSelfieAllowed = .none
    @IBOutlet private var nextView:UIView?
    @IBOutlet private var chatPupView:ButtonContainerCorners?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        paintLayers()
    }
    
    func resetSocialSelection(){
        
        isSocialYesBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        isSocialNoBtn?.backgroundColor = UIColor(hexString: "#F3E2DA")
        paintLayers()
    }
    
    
    func paintLayers(){
        
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
            self.isSocialSelfieAllowed = .yes
        }
        else if sender.tag == 1{
            
            resetSocialSelection()
            sender.backgroundColor = UIColor(hexString: "#E1E4E6")
            self.isSocialSelfieAllowed = .no
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
        
        if(isSocialSelfieAllowed == .none){
            
            socialErrorLbl?.text = "Please specify whether you want each person to receive a screenshot of their chat."
            return false
        }
        socialErrorLbl?.text = ""
        return true
    }
    
    
    func updateParam(){

        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        info.isScreenShotAllow = self.isSocialSelfieAllowed == .yes ? true:false
    }
}
