//
//  PhotoBoothView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 14/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class PhotoBoothView: ExtendedView {
    
    var eventInfo : EventInfo?
    
    @IBOutlet weak var selfieBtn : UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        hidePhotoboothcanvas()
    }
    
    func checkForAutomatedBothStyle(eventInfo : EventInfo?){
        guard let info = eventInfo else {
            return
        }
        
        if info.isHostManualScreenshot{
            self.isHidden = false
        }else{
            self.isHidden = true
        }
    }
    
    func disableBtn(){
        self.selfieBtn?.isEnabled = false
        self.selfieBtn?.setBackgroundImage(#imageLiteral(resourceName: "dot"), for: .disabled)
    }
    
    func enableBtn(){
        self.selfieBtn?.isEnabled = true
        self.selfieBtn?.setBackgroundImage(#imageLiteral(resourceName: "photoboothCam"), for: .normal)
    }
    
    func hidePhotoboothcanvas(){
        self.isHidden = true
    }
    
    func showPhotoboothcanvas(){
        self.isHidden = false
    }
    
}
