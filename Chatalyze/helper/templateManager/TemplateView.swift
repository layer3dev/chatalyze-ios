//
//  TemplateView.swift
//  ICS
//
//  Created by Sumant Handa on 16/05/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit



class TemplateView: ExtendedView {
    
    
    var containerView : UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }

    init(){
        super.init(frame : CGRect.zero )
        commonInit()
    }
    
    func nibName()->String?{
        let className = String(describing: type(of: self))
        Log.echo(key: "className", text: "className ==> " + className)
        return className
    }
    
    fileprivate func commonInit(){
        guard let nibName = nibName()
            else{
                return
        }
        let viewList  = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        
        let view  = viewList?.first as? UIView
        
        if let viewUnwrapped = view{
            containerView = viewUnwrapped
            viewUnwrapped.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            let size = viewUnwrapped.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            var frame = self.frame;
            frame.size = size;
            
            self.frame = frame
            
            self.addSubview(viewUnwrapped)
            
            fillConstraints()
            initialization()
        }
    }
    
    
    fileprivate func initialization()
    {
        paintInterface()
    }
    
    fileprivate func paintInterface(){
    
    }
    
    fileprivate func fillConstraints()
    {
        var customConstraints = [NSLayoutConstraint]()
        
        if(containerView == nil)
        {
            return
        }
        
        guard let view = containerView
            else{
                return
        }
        let bindings : [String : AnyObject] = ["view": view]
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        
        customConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
        self.addConstraints(customConstraints)
    }
}

