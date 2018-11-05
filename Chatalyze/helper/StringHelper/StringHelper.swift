//
//  StringHelper.swift
//  Chatalyze
//
//  Created by Mansa on 26/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

extension String{
    
    //Attributes text always inserted to UILable with the main thread
    
    func toAttributedString(font:String = AppThemeConfig.defaultFont , size:Int = 16 , color:UIColor = UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:Bool = false)->NSAttributedString{
        
      
        var  attributes =  [NSAttributedString.Key : Any]()
        
        if isUnderLine{
            
             attributes = [NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        }else{
            
             attributes = [NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor:color] as [NSAttributedString.Key : Any]
        }
        
        let attriutedText = NSAttributedString(string: self, attributes: attributes)
        
        return attriutedText
    }
    
    func toMutableAttributedString(font:String = AppThemeConfig.defaultFont , size:Int = 16 , color:UIColor = UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:Bool = false)->NSMutableAttributedString{
        
        var attributes = [NSAttributedString.Key : Any]()
        
        if isUnderLine {
          
            attributes = [NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        }else{
            
            attributes = [NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor: color] as [NSAttributedString.Key : Any]
        }
        
     
        let attriutedText = NSAttributedString(string: self, attributes: attributes)
        
        let mutableString = NSMutableAttributedString()
        
        mutableString.append(attriutedText)
        
        return mutableString
    }
}
