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
    @IBOutlet var photoboothWidthAnchor : NSLayoutConstraint?
    
    @IBOutlet weak var selfieBtn : UIButton?
    @IBOutlet weak var hostActionStack: UIStackView?
    
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
            showPhotoboothcanvas()
        }else{
            self.isHidden = true
            self.hostActionStack?.removeArrangedSubview(self)
            layoutIfNeeded()
        }
    }
    
    func disableBtn(){
        self.selfieBtn?.isEnabled = false
        self.selfieBtn?.setBackgroundImage(#imageLiteral(resourceName: "dot"), for: .disabled)
    }
    
    func enableBtn(){
        self.selfieBtn?.isEnabled = true
        self.selfieBtn?.setBackgroundImage(#imageLiteral(resourceName: "photoBooth"), for: .normal)
    }
    
    func hidePhotoboothcanvas(){
        disableBtn()
        self.isHidden = true
        photoboothWidthAnchor?.constant = 0
    }
    
    func showPhotoboothcanvas(){
//        self.isHidden = false
        enableBtn()
        if UIDevice.current.userInterfaceIdiom == .pad{
            photoboothWidthAnchor?.constant = 100
        }else{
            photoboothWidthAnchor?.constant = 80
        }
        layoutIfNeeded()
    }
    
}
