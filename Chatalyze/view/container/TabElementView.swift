//
//  TabElementView.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class TabElementView: ExtendedView {
    
    @IBOutlet private var tabIcon : UIImageView?
    @IBOutlet private var tabText : UILabel?
    @IBOutlet private var notificationStatusView : NotificationRoundView?
    
    var type : TabContainerView.tabType?
    var delegate : TabElementInterface?
    fileprivate var _isActionPending : Bool = false
    
    @IBAction private func tabAction(){
        
        guard let type = type
            else{
                return
        }
        delegate?.elementSelected(type: type)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
        notificationStatusView?.isHidden = true
    }
    
    public func resetTab(){
        
        tabText?.textColor = UIColor(red: 113.0/255.0, green: 135.0/255.0, blue: 146.0/255.0, alpha: 1)
        self.backgroundColor = UIColor.white
        guard let imageName = getIdealImageName()
            else{
                return
        }
        tabIcon?.image = UIImage(named: imageName)
    }
    
    public func setTab(){
        
        self.backgroundColor = UIColor.white
        tabText?.textColor = UIColor(hexString: AppThemeConfig.greenColor)
        guard let imageName = getSelectImageName()
            else{
                return
        }
        tabIcon?.image = UIImage(named: imageName)
    }
    
    private func getIdealImageName()->String?{
        
        guard let type = type
            else{
                return nil
        }
        
        switch type {
        case .event:
            return "tab_event_unselect";
        case .greeting:
            return "tab_greeting_unselect";
        case .account:
            return "tab_account_unselect"
        case .contact:
            return "contact_tab"
        }
    }
    
    private func getSelectImageName()->String?{
        guard let type = type
            else{
                return nil
        }
        
        switch type {
        case .event:
            return "tab_event_select";
        case .greeting:
            return "tab_greeting_select";
        case .account:
            return "tab_account_select"
        case .contact:
            return "contact_active_tab"
            
        }
    }
    
    var isActionPending : Bool{
        get{
            return _isActionPending
        }
        set{
            _isActionPending = newValue
            notificationStatusView?.isHidden = !newValue
        }
    }
    
}

