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
        
           Log.echo(key: "", text: "input userId ==> \(userIdW)")
            let userId = userIdW ?? ""
            let userIdIntOptional = Double(userId)
            var userIdInt : Double = 1
            
            if(userIdIntOptional != nil){
                userIdInt = userIdIntOptional!
            }
            
            var rawOne   = (userIdInt * M_PI)
           Log.echo(key: "identifier", text: "rawOne ==> \(rawOne)")
        
        
            
            let hashedDouble = rawOne - Double(UInt64(rawOne))
           Log.echo(key: "identifier", text: "hashedDouble ==> \(hashedDouble)")
        
            var hashedString = hashedDouble.toString(withDigits: 50)
           Log.echo(key: "identifier", text: "hashedString ==> \(hashedString)")
            
            hashedString = hashedString.substring(from: hashedString.characters.index(hashedString.startIndex, offsetBy: 2))
           Log.echo(key: "identifier", text: "hashedString offset by 2 ==> \(hashedString)")
        
            //hashedString = Double(hashedString)?.toString(withDigits: 16) ?? ""
            hashedString = roundOff(token : hashedString)
           Log.echo(key: "identifier", text: "hashedString offset by 16 ==> \(hashedString)")
        
            hashedString = hashedString.substring(to: hashedString.characters.index(hashedString.startIndex, offsetBy: 16))
        
            
            let characters = hashedString.characters.map{Int(String($0)) ?? 0}
        
           Log.echo(key: "identifier", text: "characters  ==> \(characters)")
            let array = characters.map { (token) -> String in
                
                let tokenInt = Int(String(token)) ?? 0
                
                let c = Character(UnicodeScalar(97 + tokenInt) ?? "0")
                let resultToken = String(c)
//                let resultToken = String(describing: )
                return resultToken
            }
        
            hashedString = array.joined(separator: "")
           Log.echo(key: "identifier", text: "output hashedString ==> \(hashedString)")
        
            return hashedString
        
    }
    
    
    
    func generateUniqueIdentifier(userId userIdW : String?)->String{
        guard let userId = userIdW
            else{
                return ""
            }
        
        Log.echo(key: "", text: "input userId ==> \(userId)")
        
        guard var userIdDouble = Double(userId)
            else{
                return ""
        }
        
        let piHash = (userIdDouble * M_PI)
        let piHashInt = IntMax(piHash) 
        let zeroFilterHash = (piHashInt | 0)
        let zeroFilteredHash = piHash - (Double(zeroFilterHash))
        
        let finalHash: IntMax = IntMax(zeroFilteredHash * pow(Double(10),Double(16)))
        var hashString = String(finalHash)
        
        let characters = hashString.characters.map{Int(String($0)) ?? 0}
        
       Log.echo(key: "", text: "characters  ==> \(characters)")
        let array = characters.map { (token) -> String in
            
            let tokenInt = Int(String(token)) ?? 0
            
            let c = Character(UnicodeScalar(97 + tokenInt) ?? "0")
            let resultToken = String(c)
            return resultToken
        }
        
        hashString = array.joined(separator: "")
       Log.echo(key: "", text: "output hashedString ==> \(hashString)")
        
        return hashString
        
        
        
        
        
    }
    
    fileprivate func roundOff(token : String)->String{
        
        var extraElement = token.substring(from: token.characters.index(token.startIndex, offsetBy: 16))
        extraElement = extraElement.substring(to: extraElement.characters.index(extraElement.startIndex, offsetBy: 1))
       Log.echo(key: "identifier", text: "extraElement ==> \(extraElement)")
        
        
        let elementValueString = token.substring(to: token.characters.index(token.startIndex, offsetBy: 16))
        
        guard let elementValue = Double(elementValueString)
            else{
                return token
        }
        
        
        
       Log.echo(key: "identifier", text: "elementValue ==> \(elementValue)")
        
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


