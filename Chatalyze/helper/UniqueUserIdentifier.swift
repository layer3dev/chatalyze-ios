//
//  UniqueUserIdentifier.swift
//  AppRTC
//
//  Created by Sumant Handa on 15/04/16.
//  Copyright © 2016 ISBX. All rights reserved.
//

import Foundation
import UIKit

class UniqueUserIdentifier{

    func identifier(withUserId userIdW : String?)->String{
        
            let userId = userIdW ?? ""
            let userIdIntOptional = Double(userId)
            var userIdInt : Double = 1
            
            if(userIdIntOptional != nil){
                userIdInt = userIdIntOptional!
            }
            
            var rawOne   = (userIdInt * M_PI)
        
        
            
            let hashedDouble = rawOne - Double(UInt64(rawOne))
        
            var hashedString = hashedDouble.toString(withDigits: 50)
        
            hashedString = hashedString.substring(from: hashedString.characters.index(hashedString.startIndex, offsetBy: 2))
        
            //hashedString = Double(hashedString)?.toString(withDigits: 16) ?? ""
            hashedString = roundOff(token : hashedString)
        
            hashedString = hashedString.substring(to: hashedString.characters.index(hashedString.startIndex, offsetBy: 16))
        
            
            let characters = hashedString.characters.map{Int(String($0)) ?? 0}
        
            let array = characters.map { (token) -> String in
                
                let tokenInt = Int(String(token)) ?? 0
                
                let c = Character(UnicodeScalar(97 + tokenInt) ?? "0")
                let resultToken = String(c)
//                let resultToken = String(describing: )
                return resultToken
            }
        
            hashedString = array.joined(separator: "")
        
            return hashedString
        
    }
    
    
    
    func generateUniqueIdentifier(userId userIdW : String?)->String{
        guard let userId = userIdW
            else{
                return ""
            }
        
        
        guard var userIdDouble = Double(userId)
            else{
                return ""
        }
        
        let piHash = (userIdDouble * Double.pi)
        let piHashInt = Int64(piHash)
        let zeroFilterHash = (piHashInt | 0)
        let zeroFilteredHash = piHash - (Double(zeroFilterHash))
        
        let finalHash: Int64 = Int64(zeroFilteredHash * pow(Double(10),Double(16)))
        var hashString = String(finalHash)
        
        let characters = hashString.characters.map{Int(String($0)) ?? 0}
        
        let array = characters.map { (token) -> String in
            
            let tokenInt = Int(String(token)) ?? 0
            
            let c = Character(UnicodeScalar(97 + tokenInt) ?? "0")
            let resultToken = String(c)
            return resultToken
        }
        
        hashString = array.joined(separator: "")
        
        return hashString
        
        
        
        
        
    }
    
    fileprivate func roundOff(token : String)->String{
        
        var extraElement = token.substring(from: token.characters.index(token.startIndex, offsetBy: 16))
        extraElement = extraElement.substring(to: extraElement.characters.index(extraElement.startIndex, offsetBy: 1))
        
        
        let elementValueString = token.substring(to: token.characters.index(token.startIndex, offsetBy: 16))
        
        guard let elementValue = Double(elementValueString)
            else{
                return token
        }
        
        
        
        
        let extraValue = Int(extraElement) ?? 0
        if(extraValue >= 5){
            let value = elementValue + 1
            return String(format: "%.16f", value)
        }
        
        return String(format: "%.16f", elementValue)
    }
}



extension Double {
    func toString(withDigits digits: UInt) -> String {
        return String(format: "%.\(digits)f", self)
    }
}


