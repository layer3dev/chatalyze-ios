//
//  SelectedMultipleColorClassView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 22/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import Foundation

class SelectedMultipleColorClassView: ExtendedView {
    
    var updateSelecetdButtonColorDelegate:UpdatForSelectedColorProtocol?
    @IBOutlet var colorPicker:SwiftHSVColorPicker?
    @IBOutlet var colorTapView:UIView?
    let selectedColor:UIColor = UIColor.white
    @IBOutlet var mainColorView:UIView?
    
    override func viewDidLayout(){
        super.viewDidLayout()
        
        initialize()
        paintInterface()
    }
    
    private func paintInterface(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        colorTapView?.addGestureRecognizer(tap)
        colorPicker?.setViewColor(selectedColor)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        mainColorView?.isHidden = true
    }
    
    fileprivate func initialize(){
        
        paintContainerBorder()
    }
    
    fileprivate func paintContainerBorder(){
        
        let layer = self.layer
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    fileprivate func paintShadow(){
        
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        let shadowSize : CGFloat = 5.0
        //ContainerView has 8.0 margins from all the sides in the Storyboard
        let layerExactHeight:CGFloat = self.frame.size.height
        let layerExactWidth:CGFloat = self.frame.size.width
        layer.shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                     y: -shadowSize / 2,
                                                     width: layerExactWidth + shadowSize,
                                                     height: layerExactHeight + shadowSize)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    @IBAction func selectColorAction(){
        
        guard let getColor = colorPicker?.color else{
            return
        }
        updateSelecetdButtonColorDelegate?.updateForColorForSelectedButton(color: getColor)
    }
}

extension UIColor {
    
    func rgb() -> Int? {
        
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
