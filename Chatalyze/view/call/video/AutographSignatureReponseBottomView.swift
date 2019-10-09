//
//  AutographSignatureReponseBottomView.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 21/08/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographSignatureReponseBottomView: ExtendedView {
    
    @IBOutlet var colorView:UIView?
    var delegate:AutographSignatureBottomResponseInterface?
    @IBOutlet var ColorViewClass:SelectedMultipleColorClassView?

    var brush: CGFloat = 8.5
    var opacity: CGFloat = 1.0
    var red: CGFloat = 1.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0

    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        ColorViewClass?.updateSelecetdButtonColorDelegate = self
    }
    
    func paintInterface(){
        
        colorView?.layer.borderWidth = UIDevice.current.userInterfaceIdiom == .pad ? 2.0:1.0
        colorView?.layer.borderColor = UIColor(red:224.0/255.0 , green: 224.0/255.0, blue: 224.0/255.0, alpha: 1).cgColor
        colorView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 25.0:20.0
        colorView?.backgroundColor = UIColor.black
        colorView?.layer.masksToBounds = true
    }
    
    @IBAction func undoAction(sender:UIButton?){
        self.delegate?.undoAction(sender: sender)
    }
    
    @IBAction func doneAction(sender:UIButton?){
        self.delegate?.doneAction(sender:sender)
    }
    
    @IBAction func colorAction(sender:UIButton?){
        ColorViewClass?.mainColorView?.isHidden = false
    }
    
    @IBAction func colorPick(_ sender: UIButton){
        
        var fRed : CGFloat = 1.0
        var fGreen : CGFloat = 0.0
        var fBlue : CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        
        if (sender.backgroundColor?.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha))! {
            
            Log.echo(key: "", text:"test color if")
            if fRed < 0{
                fRed = -(fRed)
            }
            if fGreen < 0{
                fGreen = -(fGreen)
            }
            if fBlue < 0{
                fBlue = -(fBlue)
            }
            red = fRed
            green = fGreen
            blue = fBlue
            opacity = fAlpha
        }
    }
}
extension AutographSignatureReponseBottomView:UpdatForSelectedColorProtocol{
        
    func updateForColorForSelectedButton(color:UIColor){
        
        self.colorView?.backgroundColor = color
        self.delegate?.pickerSelectedColor(color:color)
    }
}


