


//
//  ExtendedLabel.swift
//  BN PERKS
//
//  Created by Sumant Handa on 11/07/17.
//  Copyright © 2017 Mansa. All rights reserved.
//

import UIKit

class ExtendedLabel: UILabel {

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
    
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        Log.echo(key: "", text: "didMoveToSuperview")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
        Log.echo(key: "", text: "removeFromSuperview")
    }
    
    func viewDidLayout(){
        
    }

}
