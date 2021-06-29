//
//  UserSelfieBooth.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 29/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation



class UserSelfieBooth: SelfieWindowView {
    
    
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
            self.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 580, height: 580))
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
    // shows selfieBooth
    override func show() {
        self.finalMemoryImg = nil
        self.streamStackViews?.isHidden = false
        self.isHidden = false
    }
    
    // will set image on selfie frame
    override func setSelfieImage(with image: UIImage?) {
        guard let image = image else{
            Log.echo(key: "AbhishekD", text: "No Image found!")
            return
        }
        memoryImage?.image = image
        self.streamStackViews?.isHidden = true
    }
 
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
