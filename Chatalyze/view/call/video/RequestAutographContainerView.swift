//
//  RequestAutographContainerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 04/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RequestAutographContainerView: ExtendedView {
    
    @IBOutlet private var loaderView : LoaderView?
    @IBOutlet private var icon : UIImageView?
    @IBOutlet private var button : UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    private func initialization(){
        initializeVariable()
    }
    
    private func initializeVariable(){
    }
    
    func showLoader(){
        
        loaderView?.loader?.startAnimating()
        button?.isEnabled = false
    }
    
    func hideLoader(){
        
        loaderView?.loader?.stopAnimating()
        button?.isEnabled = true
    }
    
    func disable(){
        button?.isEnabled = false
    }
    
    func enable(){
    }
}
