//
//  Constraints.swift
//  Chatalyze
//
//  Created by Mansa Mac-3 on 7/2/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
  func anchor(top:NSLayoutYAxisAnchor?,leading:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,trailing:NSLayoutXAxisAnchor?,padding:UIEdgeInsets = .zero,size:CGSize = .zero){

    translatesAutoresizingMaskIntoConstraints = false

    if let top = top{
       topAnchor.constraint(equalTo: top,constant: padding.top).isActive = true
    }

    if let leading = leading{
       leadingAnchor.constraint(equalTo: leading,constant: padding.left).isActive = true
    }

    if let trailing = trailing{
       trailingAnchor.constraint(equalTo: trailing,constant: -padding.right).isActive = true
    }

    if let bottom = bottom{
       bottomAnchor.constraint(equalTo: bottom,constant: -padding.bottom).isActive = true
    }


    if size.width != 0{
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }

    if size.height != 0{
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }


  }
}

extension UIColor {

convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {

  self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
}
}

extension NSAttributedString {

   static func makeHyperLink(path:String,string: String,substring:String) -> NSAttributedString {
    let nsString = NSString(string: string)
    let subStringRange = nsString.range(of: substring)
    let attributedString = NSMutableAttributedString(string: string)
    attributedString.addAttribute(.link, value:path, range: subStringRange)
    return attributedString
  }

}
