//
//  ExtendedTextView.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class ExtendedTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    private var isLoaded = false;
    
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
    
    func viewDidLayout(){
        
    }
    
    

}
