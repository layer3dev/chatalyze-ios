//
//  ExtendedView.swift
//  GenGold
//
//  Created by Sumant Handa on 19/11/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class ExtendedView: UIView {
    
     private var isLoaded = false;
     private var isLayoutCompleted = false
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!isLoaded){
            isLoaded = true
            viewDidLayout()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        if(!isLayoutCompleted){
            isLayoutCompleted = true
            viewDidLoad()
        }
    }
    
    func viewDidLoad(){
    
    }
    
    func viewDidLayout(){
        
    }

}
