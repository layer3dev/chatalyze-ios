//
//  AspectImageView.swift
//  GenGold
//
//  Created by Sumant Handa on 15/03/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import UIKit

class AutoAspectImageView: ExtendedImageView {
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var heightConstraint : NSLayoutConstraint?;
    var widthConstraint : NSLayoutConstraint?;
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        Log.echo(key: "AutoAspectImageView", text: "viewDidLayout")
        //updateConstraint()
    }
    
    
   
    
    
    @IBInspectable var widthAspect : Int = 0
    
    @IBInspectable override var image : UIImage?{
        get{
            return super.image
        }
        set{
            super.image = newValue
            
            Log.echo(key: "AutoAspectImageView", text: "setImage")
            updateConstraint()
        }
    }

}


extension AutoAspectImageView {
    
    fileprivate func updateConstraint(){
        Log.echo(key: "AutoAspectImageView", text: "updateConstraint")
        if(widthAspect == 0){
            Log.echo(key: "AutoAspectImageView", text: "updateImageViewHeight")
            updateImageViewHeight()
            return
        }
        Log.echo(key: "AutoAspectImageView", text: "updateImageViewWidth")
        updateImageViewWidth()
    }
    
    fileprivate func updateImageViewHeight(){
        if(heightConstraint == nil){
            initializeHeightConstraint()
            return
        }
        
        heightConstraint?.constant = calculateHeight()
    }
    
    fileprivate func updateImageViewWidth(){
        if(widthConstraint == nil){
            initializeWidthConstraint()
            return
        }
        widthConstraint?.constant = calculateWidth()
    }
    
    
    fileprivate func initializeHeightConstraint(){
        let imageHeight = calculateHeight()
        if(imageHeight == 0){
            return
        }
        heightConstraint = NSLayoutConstraint(
            item:self, attribute:NSLayoutConstraint.Attribute.height,
            relatedBy:NSLayoutConstraint.Relation.equal,
            toItem:nil, attribute:NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier:0, constant:imageHeight)
        heightConstraint?.priority = UILayoutPriority(rawValue: 999);
        guard let heightConstraintUnWrapped = heightConstraint
            else{
                return;
        }
        self.addConstraint(heightConstraintUnWrapped)
    }
    
    
    fileprivate func initializeWidthConstraint(){
        
        let imageWidth = calculateWidth()
        if(imageWidth == 0){
            return
        }
        widthConstraint = NSLayoutConstraint(
            
            item:self, attribute:NSLayoutConstraint.Attribute.width,
            relatedBy:NSLayoutConstraint.Relation.equal,
            toItem:nil, attribute:NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier:0, constant:imageWidth)
        widthConstraint?.priority = UILayoutPriority(rawValue: 999);
        
        guard let widthConstraintUnWrapped = widthConstraint
            else{
                return;
        }
        self.addConstraint(widthConstraintUnWrapped)
    }
    
    
    fileprivate func calculateWidth() -> CGFloat{
        
        Log.echo(key: "AutoAspectImageView", text: "calculateWidth")
        guard let newImage = image
            else{
                Log.echo(key: "AutoAspectImageView", text: "0 width")
                return 0
        }
        
        
        Log.echo(key: "AutoAspectImageView", text: "newImage height -> \(newImage.size.height)")
        Log.echo(key: "AutoAspectImageView", text: "self.bounds.height -> \(self.bounds.height)")
        let multiplier : CGFloat = (self.bounds.height / newImage.size.height);
        
        let newWidth =  multiplier * newImage.size.width
        Log.echo(key: "AutoAspectImageView", text: "newWidth -> \(newWidth)")
        return newWidth
    }
    
    fileprivate func calculateHeight() -> CGFloat{
        guard let newImage = image
            else{
                return 0
        }

        let multiplier : CGFloat = (self.bounds.width / newImage.size.width);
        let newHeight =  multiplier * newImage.size.height
        return newHeight
    }
}


