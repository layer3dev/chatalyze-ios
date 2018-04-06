//
//  LoaderView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: ExtendedView {
    
    var loader : NVActivityIndicatorView?

    override func viewDidLayout() {
        super.viewDidLayout()
    
        initialization()
    }
    
    private func initialization(){
        let loader = NVActivityIndicatorView(frame: self.bounds, type: .circleStrokeSpin, color: UIColor.blue, padding: 0.0)
        self.loader = loader
        self.addSubview(loader)
    }
    
    
    
}
