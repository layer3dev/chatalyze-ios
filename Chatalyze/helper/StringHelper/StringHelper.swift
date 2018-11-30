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
    
    func toAttributedStringLink(font:String = AppThemeConfig.defaultFont , size:Int = 16 , color:UIColor = UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:Bool = false)->NSAttributedString{
        
        var  attributes =  [NSAttributedString.Key : Any]()
        
        if isUnderLine{
            
            attributes = [NSAttributedString.Key.link:URL(string: "https://www.google.com"),NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        }else{
            
            attributes = [NSAttributedString.Key.link:URL(string: "https://ww.google.com"),NSAttributedString.Key.font:UIFont(name: font, size:CGFloat(size)),NSAttributedString.Key.foregroundColor:color] as [NSAttributedString.Key : Any]
        }
        
        let attriutedText = NSAttributedString(string: self, attributes: attributes)
        
        return attriutedText
    }
    
    
    
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


extension String {
    
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}


//extension Double {
//    func roundTo(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//}
