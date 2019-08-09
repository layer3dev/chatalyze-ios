//
//  CanvasContainer.swift
//  Chatalyze
//
//  Created by Sumant Handa on 11/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class CanvasContainer: ExtendedView {
    
    @IBOutlet var canvas : AutographyCanvas?
    @IBOutlet var canvasHeightZeroConstraint : NSLayoutConstraint?
    @IBOutlet var canvasProportionalHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet var topConstraint:NSLayoutConstraint?
    @IBOutlet var trailingConstraint:NSLayoutConstraint?
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    
    func show(){
        
        layoutIfNeeded()
        showInPortrait()
        UIView.animate(withDuration: 1.0) {
            self.layoutIfNeeded()
        }
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Log.echo(key: "yud", text: "Canvas container height width is \(self.frame.size.width) and the canvas height is \(self.frame.size.height)")
    }
}
