//
//  UINib.swift
//  GGStaff
//
//  Created by Sumant Handa on 29/07/16.
//  Copyright © 2016 GenGold. All rights reserved.
//

import Foundation
import UIKit


public extension UINib {
   
     public static func universalNib(nibName : String, bundle : Bundle? = nil)->UINib{
        let name = nibName + (UIDevice.current.userInterfaceIdiom == .pad ? "_iPad" : "_iPhone")
        return UINib(nibName : name, bundle : nil)
    }
}
