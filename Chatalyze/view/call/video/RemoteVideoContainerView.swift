//
//  RemoteVideoContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 09/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class RemoteVideoContainerView: ExtendedView {

    @IBOutlet var remoteVideoView : RemoteVideoView?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //***
    
    @IBOutlet private var leadingMain : NSLayoutConstraint?
    @IBOutlet private var trailingMain : NSLayoutConstraint?
    @IBOutlet private var topMain : NSLayoutConstraint?
    @IBOutlet private var bottomMain : NSLayoutConstraint?
    
    @IBOutlet private var leadingCustom : NSLayoutConstraint?
    @IBOutlet private var trailingCustom : NSLayoutConstraint?
    @IBOutlet private var topCustom : NSLayoutConstraint?
    @IBOutlet private var bottomCustom : NSLayoutConstraint?
        
    
    func updateForSignature(){
        
        leadingMain?.priority = UILayoutPriority(rawValue: 250.0)
        trailingMain?.priority = UILayoutPriority(rawValue: 250.0)
        topMain?.priority = UILayoutPriority(rawValue: 250.0)
        bottomMain?.priority = UILayoutPriority(rawValue: 250.0)
        
        leadingCustom?.priority = UILayoutPriority(rawValue: 999.0)
        trailingCustom?.priority = UILayoutPriority(rawValue: 999.0)
        topCustom?.priority = UILayoutPriority(rawValue: 999.0)
        bottomCustom?.priority = UILayoutPriority(rawValue: 999.0)
    }
    
    func updateForCall(){
        
        leadingMain?.priority = UILayoutPriority(rawValue: 999.0)
        trailingMain?.priority = UILayoutPriority(rawValue: 999.0)
        topMain?.priority = UILayoutPriority(rawValue: 999.0)
        bottomMain?.priority = UILayoutPriority(rawValue: 999.0)
        
        leadingCustom?.priority = UILayoutPriority(rawValue: 250.0)
        trailingCustom?.priority = UILayoutPriority(rawValue: 250.0)
        topCustom?.priority = UILayoutPriority(rawValue: 250.0)
        bottomCustom?.priority = UILayoutPriority(rawValue: 250.0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        remoteVideoView?.updateContainerSize(containerSize: self.bounds.size)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }

}
