//
//  ScheduleSessionTitleRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol ScheduleSessionTitleRootViewDelegate {
    
    func getSchduleSessionInfo()->ScheduleSessionInfo?
    func goToNextScreen()
}

class ScheduleSessionTitleRootView: ExtendedView{
    
    var delegate:ScheduleSessionTitleRootViewDelegate?
    
    @IBOutlet var titleField:SigninFieldView?
    
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet var scrollContentBottonOffset:NSLayoutConstraint?
    
    @IBOutlet private var nextView:UIView?
    @IBOutlet private var chatPupView:ButtonContainerCorners?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.titleField?.textField?.doneAccessory = true
        self.titleField?.isCompleteBorderAllow = true
        self.titleField?.textField?.delegate = self
        initializeVariable()
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
    
    func initializeVariable(){
        
        scrollView?.bottomContentOffset = scrollContentBottonOffset
    }
    
    func updateParameter(){
        
        guard let info = delegate?.getSchduleSessionInfo() else{
            return
        }
        
        info.title = titleField?.textField?.text
    }
    
    
    //MARK:- Button Action
    
    @IBAction func nextAction(sender:UIButton?){
        
        if(!validateFields()){
            return
        }
        self.resetErrorStatus()
        updateParameter()
        delegate?.goToNextScreen()
    }
}


extension ScheduleSessionTitleRootView:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        scrollView?.activeField = titleField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}


extension ScheduleSessionTitleRootView{
    
    func resetErrorStatus(){
        
        titleField?.resetErrorStatus()
    }
    
    func validateFields()->Bool{
        
        let titleValidated  = titleValidation()
        return titleValidated
    }
    
    fileprivate func titleValidation()->Bool{
        
        if(titleField?.textField?.text?.replacingOccurrences(of: " ", with: "") ?? "" == ""){
            
            titleField?.showError(text: "Title is required.")
            return false
        }
        titleField?.resetErrorStatus()
        return true
    }
    
    func showError(message:String?){
        //errorLbl?.text =  message ?? ""
    }
}
