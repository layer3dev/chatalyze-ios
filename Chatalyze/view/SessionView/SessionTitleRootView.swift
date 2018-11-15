//
//  SessionTitleRootView.swift
//  Chatalyze
//
//  Created by Mansa on 09/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


class SessionTitleRootView:ExtendedView{
    
    @IBOutlet var titleField:SigninFieldView?
    
    override func viewDidLayout(){
        super.viewDidLayout()        
    }
    
    
   
    func validateFields()->Bool{
        
        let titleValidated  = validateTitle()
        return titleValidated
    }
    
    fileprivate func validateTitle()->Bool{
        
        if(titleField?.textField?.text == ""){
            
            titleField?.showError(text: "Title field can't be left empty !")
            return false
        }
        titleField?.resetErrorStatus()
        return true
    }

    @IBAction fileprivate func nextAction(){
        
        if(validateFields()){
            next()
        }
    }
    
    func next(){
        
        //guard let controller = Sessio
    }
}
