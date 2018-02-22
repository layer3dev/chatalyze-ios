//
//  Date.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 05/01/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    
    
    func toString()->String?{
        let defaultFormat = "MMM d, yyyy"
        return DateParser.dateToString(self, requiredFormat : defaultFormat)
    }

}
