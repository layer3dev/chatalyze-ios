//
//  AspectImageView.swift
//  GenGold
//
//  Created by Sumant Handa on 15/03/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit
@IBDesignable
class AspectImageView: UIImageView {
    
    var heightConstraint : NSLayoutConstraint?
    var widthConstraint : NSLayoutConstraint?
    
    @IBInspectable override var image : UIImage?{
        get{
            return super.image
        }
        set{
            super.image = newValue
            updateImageViewSizeConstraint()
        }
    }
}


extension AspectImageView {
    
    fileprivate func updateImageViewSizeConstraint(){

        guard let size = calculateSize()
            else{
                return
        }
        
        let height = size.height
        let width = size.width
        
        if(heightConstraint == nil){
            
            initializeHeightConstraint(imageHeight: height)
             layoutIfNeeded()
        }else{
            heightConstraint?.constant = height
            layoutIfNeeded()
        }
        
        if(widthConstraint == nil){
            initializeWidthConstraint(imageWidth: width)
            layoutIfNeeded()
        }else{
            widthConstraint?.constant = width
            layoutIfNeeded()
        }
    }
    
    
    fileprivate func initializeHeightConstraint(imageHeight : CGFloat){
        
        if(imageHeight == 0){
            return
        }
        
        heightConstraint = NSLayoutConstraint(
            item:self, attribute:NSLayoutConstraint.Attribute.height,
            relatedBy:NSLayoutConstraint.Relation.equal,
            toItem:nil, attribute:NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier:0, constant:imageHeight)
        
        heightConstraint?.priority = UILayoutPriority(rawValue: 999)
        
        guard let heightConstraintUnWrapped = heightConstraint
            else{
                return
        }
        
        self.addConstraint(heightConstraintUnWrapped)
    }
    
    fileprivate func initializeWidthConstraint(imageWidth : CGFloat){
        
        if(imageWidth == 0){
            return
        }
        
        widthConstraint = NSLayoutConstraint(
            item:self, attribute:NSLayoutConstraint.Attribute.width,
            relatedBy:NSLayoutConstraint.Relation.equal,
            toItem:nil, attribute:NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier:0, constant:imageWidth)
        
        widthConstraint?.priority = UILayoutPriority(rawValue: 999)
        
        guard let widthConstraintUnWrapped = widthConstraint
            else{
                return
        }
        
        self.addConstraint(widthConstraintUnWrapped)
    }
    
    fileprivate func calculateSize()->CGRect?{
        
        guard let image = image
            else{
                return nil
        }
        
        Log.echo(key: "yud", text: "self canvase bounds during calculating the image is  \(self.bounds)")
        
        
        let size = AVMakeRect(aspectRatio: image.size, insideRect: self.bounds)
        return size
    }
    
    fileprivate func calculateHeight() -> CGFloat{
        
        guard let newImage = image
            else{
                return 0
        }
        
        var multiplier : CGFloat = (self.bounds.width / newImage.size.width);
        if(multiplier > 1){
            multiplier = 1
        }
        let newHeight =  multiplier * newImage.size.height
        return newHeight
    }
    
    func updateFrames(){
        
        updateImageViewSizeConstraint()
    }
}


