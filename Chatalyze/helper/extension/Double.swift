//
//  Double.swift
//  GenGold
//
//  Created by Sumant Handa on 19/11/16.
//  Copyright © 2016 Mansa. All rights reserved.
//

import Foundation

extension Double {
    func truncatedDecimalString(fractionDigits : Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    /// Rounds the double to decimal places value (just truncate upto that decimal number not rounding off)
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
