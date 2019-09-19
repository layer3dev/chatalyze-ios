//
//  CanvasContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CanvasContainer: ExtendedView {
    
    var isSignatureActive = false
    
    @IBOutlet var canvas : AutographyCanvas?
    @IBOutlet var canvasHeightZeroConstraint : NSLayoutConstraint?
    @IBOutlet var canvasProportionalHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet var topConstraint:NSLayoutConstraint?
    @IBOutlet var trailingConstraint:NSLayoutConstraint?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialization()
    }
    
    func initialization(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func didRotate() {
        
        self.updateLayoutRotation()
    }
    
    func updateLayoutRotation() {
        
        if UIDevice.current.orientation.isPortrait {
            if UIDevice.current.userInterfaceIdiom == .phone {
                
                topConstraint?.constant = 144
                trailingConstraint?.constant = 0

            }else{
                
                topConstraint?.constant = 220
                trailingConstraint?.constant = 0
                
            }
            return
        }
        
        if UIDevice.current.orientation.isLandscape{
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                topConstraint?.constant = 15
                trailingConstraint?.constant = 244
         
            }else{
               
                topConstraint?.constant = 15
                trailingConstraint?.constant = 148
                
            }
            return
        }
        return
    }
    
    
    func show(with image:UIImage?,info:CanvasInfo?){
        
        guard let canvasImage = image else{
            return
        }
        
        guard let canvasInfo = info else{
            return
        }
        
        layoutIfNeeded()
        showInPortrait()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        
        let newCanvasFrame = AVMakeRect(aspectRatio: canvasImage.size, insideRect: self.frame)
        
        Log.echo(key: "yud", text: "user host canvas frame is \(newCanvasFrame)")
      
        self.canvas?.mainImageView?.reset()
        canvas?.heightConstraint?.constant = newCanvasFrame.height
        canvas?.widthConstraint?.constant = newCanvasFrame.width
        canvas?.mainImageView?.image = canvasImage
        canvas?.mainImageView?.canvasInfo = canvasInfo
        
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
        self.hideCanvas()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
        self.reloadCanvas()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func reloadCanvas(){
        
        self.canvas?.mainImageView?.image = nil
        self.canvas?.mainImageView?.reset()
        self.canvas?.heightConstraint?.constant = 0.0
        self.canvas?.widthConstraint?.constant = 0.0
        self.isSignatureActive = false
    }
}
