//
//  BoldAttribute.swift
//  BN PERKS
//
//  Created by Sumant Handa on 02/11/17.
//  Copyright © 2017 Mansa. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    @discardableResult func appendCustom(_ text:String, size : CGFloat = 14, color : UIColor = UIColor.black) -> NSMutableAttributedString {
        guard let font = UIFont(name: "HelveticaNeue", size: size)
            else{
                return NSMutableAttributedString(string : text)
        }
        
        var attrs:[NSAttributedString.Key:Any]  = [NSAttributedString.Key:Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        
        let boldString = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(boldString)
        return self
    }

    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
