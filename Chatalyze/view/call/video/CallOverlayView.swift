

//
//  CallOverlayView.swift
//  Rumpur
//
//  Created by Sumant Handa on 20/03/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class CallOverlayView: TemplateView {
    
    var userInfo : UserInfo?
    private var hangupListener : (()->())?
    
    @IBAction fileprivate func hangupAction(){
        hangupListener?()
    }

    @IBOutlet private var username : UILabel?
    @IBOutlet private var userImage : UIImageView?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    func hangupListener(listener : (()->())?){
        self.hangupListener = listener
    }
    
    private func initialization(){
        
    }

}
