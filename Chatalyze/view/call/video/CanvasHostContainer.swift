//
//  CanvasHostContainer.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 14/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class CanvasHostContainer: ExtendedView {
    
    var isSignatureActive = false
    @IBOutlet private var canvas : AutographyHostCanvas?
    @IBOutlet var canvasHeightZeroConstraint : NSLayoutConstraint?
    @IBOutlet var canvasProportionalHeightConstraint : NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func getCanvasReference()->AutographyHostCanvas?{
        return self.canvas
    }
    
    func show(with image:UIImage?){
        
        guard let canvasImage = image else{
            return
        }
        layoutIfNeeded()
        showInPortrait()
        
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        
        let newCanvasFrame = AVMakeRect(aspectRatio: canvasImage.size, insideRect: self.frame)
        
        self.canvas?.mainImageView?.reset()
        canvas?.heightConstraint?.constant = newCanvasFrame.height
        canvas?.widthConstraint?.constant = newCanvasFrame.width
        canvas?.mainImageView?.image = canvasImage
        canvas?.counter = 0
        self.isSignatureActive = true
    }
    
    private func showInPortrait(){
        
        canvasHeightZeroConstraint?.priority = UILayoutPriority(1.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(990.0)
    }
    
    private func hideCanvas(){
        
        canvasHeightZeroConstraint?.priority = UILayoutPriority(990.0)
        canvasProportionalHeightConstraint?.priority = UILayoutPriority(1.0)
    }
    
    func hide(){
        
        layoutIfNeeded()
        hideCanvas()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        reloadCanvas()
    }
    
    private func reloadCanvas(){
        
        self.canvas?.mainImageView?.image = nil
        self.canvas?.mainImageView?.reset()
        self.canvas?.heightConstraint?.constant = 0.0
        self.canvas?.widthConstraint?.constant = 0.0
        self.isSignatureActive = false
    }
}
