//
//  RotationListenerView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 30/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class RotationListenerView: ExtendedView {

   /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var shouldListenToOrientation : Bool{
        get{
            return false
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        initialization()
    }
    
    
    private func initialization(){
        if(!shouldListenToOrientation){
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRotateListener), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func didRotateListener(){
        didRotate()
    }
    
    //will be overriden by subclasses
    func didRotate(){
        
    }
    
    

}
