//
//  AnimateLable.swift
//  Chatalyze
//
//  Created by Mansa on 18/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AnimateLable :ExtendedView{
    
    var label = UILabel()
    var crossFading: Bool  = false
    let duration = 0.75
    let fontSizeSmall: CGFloat = 30
    let fontSizeBig: CGFloat = 120
    var isSmall: Bool = true
    
    @IBAction func reset(_ sender: Any) {
        
        var bounds = label.bounds
        label.font = label.font.withSize(fontSizeSmall)
        bounds.size = label.intrinsicContentSize
        label.bounds = bounds
        isSmall = true
    }
    
    @IBAction func animateFont(_ sender: Any) {
        
        if isSmall {
            if crossFading {
                enlargeWithCrossFade()
            } else {
                enlarge()
            }
        } else {
            if crossFading {
                shrinkWithCrossFade()
            } else {
                shrink()
            }
        }
        isSmall = !isSmall
    }
    
    func enlarge() {
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        label.bounds = biggerBounds
        
        //        UIView.animate(withDuration: duration) {
        //            self.label.transform = .identity
        //        }
        //
        
        //Animated
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            
        }) { (success) in
            self.shrink()
        }
    }
    
    func enlargeWithCrossFade() {
        
        let labelCopy = label.copyLabel()
       // view.addSubview(labelCopy)
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        let enlargeTransform = scaleTransform(from: label.bounds.size, to: biggerBounds.size)
        label.bounds = biggerBounds
        label.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            labelCopy.transform = enlargeTransform
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
        
        UIView.animate(withDuration: duration / 2) {
            self.label.alpha = 1.0
            labelCopy.alpha = 0.0
        }
    }
    
    func shrink() {
        
        let labelCopy = label.copyLabel()
        var smallerBounds = labelCopy.bounds
        labelCopy.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = labelCopy.intrinsicContentSize
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = shrinkTransform
        }, completion: { done in
            self.label.font = labelCopy.font
            self.label.transform = .identity
            self.label.bounds = smallerBounds
            self.enlarge()
        })
    }
    
    func shrinkWithCrossFade() {
        
        let labelCopy = label.copyLabel()
        //view.addSubview(labelCopy)
        
        var smallerBounds = label.bounds
        label.font = label.font.withSize(fontSizeSmall)
        smallerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: smallerBounds.size, to: label.bounds.size)
        label.alpha = 0.0
        
        let shrinkTransform = scaleTransform(from: label.bounds.size, to: smallerBounds.size)
        
        UIView.animate(withDuration: duration, animations: {
            labelCopy.transform = shrinkTransform
            self.label.transform = .identity
        }, completion: { done in
            self.label.transform = .identity
            self.label.bounds = smallerBounds
        })
        
        let percUntilFade = 0.8
        UIView.animate(withDuration: duration - (duration * percUntilFade), delay: duration * percUntilFade, options: .curveLinear, animations: {
            labelCopy.alpha = 0
            self.label.alpha = 1
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
}

extension UILabel {
    
    func copyLabel() -> UILabel {
        
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
    }
}
