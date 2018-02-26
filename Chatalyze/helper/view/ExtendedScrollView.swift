//
//  ExtendedScrollView.swift
//  BN PERKS
//
//  Created by Sumant Handa on 09/06/17.
//  Copyright © 2017 Mansa. All rights reserved.
//

import UIKit

class ExtendedScrollView: UIScrollView {
    
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
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }


}
