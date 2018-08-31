//
//  EditScheduledSessionRootView.swift
//  Chatalyze
//
//  Created by Yudhisther on 30/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EditScheduledSessionRootView:ExtendedView{

    @IBOutlet var namePriceViewHieghtConstraints:NSLayoutConstraint?
    @IBOutlet var namePriceViewBottomConstraints:NSLayoutConstraint?

    @IBOutlet var namePriceEditViewHieghtConstraints:NSLayoutConstraint?
    @IBOutlet var namePriceEditViewBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var descriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var descriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var editDescriptionHeightConstraints:NSLayoutConstraint?
    @IBOutlet var editDescriptionBottomConstraints:NSLayoutConstraint?
    
    @IBOutlet var sessionNameLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
    }
    
    func initializeVariable(){
        
        implementGestureOnEditSessionName()
    }
    
    func implementGestureOnEditSessionName(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.editSessionNameAction))
        self.sessionNameLbl?.isUserInteractionEnabled = true
        self.sessionNameLbl?.isEnabled = true
        sessionNameLbl?.addGestureRecognizer(tapGesture)
    }
    
    func hideNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceInfoView(){
        
        namePriceViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showNamePriceEditInfoView(){
        
        namePriceEditViewHieghtConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showDescriptionInfoView(){
        
        descriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    func hideEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(999.0)
    }
    
    func showEditDescriptionInfoView(){
        
        editDescriptionHeightConstraints?.priority = UILayoutPriority(250.0)
    }
    
    @objc func editSessionNameAction(){
        
        showNamePriceEditInfoView()
        hideNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditSessionNameAction(){

        hideNamePriceEditInfoView()
        showNamePriceInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func editDescriptionAction(){
        
        hideDescriptionInfoView()
        showEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
    
    @IBAction func disableEditDescriptionAction(){
        
        showDescriptionInfoView()
        hideEditDescriptionInfoView()
        self.layoutIfNeeded()
    }
    
}
