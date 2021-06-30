//
//  HostSelfieBoothView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 29/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation

class HostSelfieBoothView: SelfieWindowView {
    
   @IBOutlet var containerWidthAnchor : NSLayoutConstraint?
   @IBOutlet var conatinerheightAnchor : NSLayoutConstraint?
    @IBOutlet var memoryImage : UIImageView?
    
    // size for iPad
    var widthSize : CGFloat =  0.8
    var heightSize: CGFloat =  0.4
    
    override func viewDidLayout() {
        super.viewDidLayout()
        handleViewConstarints()
        paintInterface()
    }
    
    func handleViewConstarints(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.conatinerheightAnchor?.isActive = false
            self.containerWidthAnchor?.isActive = false
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 650, height: 650))
        }else{
            self.conatinerheightAnchor?.isActive = false
            self.containerWidthAnchor?.isActive = false
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 350, height: 350))
        }
        layoutIfNeeded()
    }
    func paintInterface(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.layer.cornerRadius = 16
        }else{
            self.layer.cornerRadius = 12
        }
    }
        
    override func setSelfieImage(with image:UIImage?){
        
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        self.memoryImage?.image = image
        self.streamStackViews?.isHidden = true
        self.selfieActionContainer?.enableRetakeAndSave()
    }
    
    override func show(){
        self.memoryImage?.image = nil
        self.streamStackViews?.isHidden = false
        self.selfieActionContainer?.enableCamera()
        self.isHidden = false
    }
    
}
