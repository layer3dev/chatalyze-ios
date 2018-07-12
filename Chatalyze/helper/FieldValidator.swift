//
//  FieldValidator.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 26/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation

class FieldValidator {
    
    static let sharedInstance = FieldValidator()
    
    func validateEmailFormat(_ text : String)->Bool{
       
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        let emailRegex = laxString;
        let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex);
        return emailTest.evaluate(with: text);
    }
    
    func validateNumberString(_ text : String)->Bool{
        
        let regEx = "^[0-9]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        let success = predicate.evaluate(with: text)
        return success
    }
    
    func validatePlainString(_ text : String)->Bool{
        
        let regEx = "^[a-zA-Z ]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        let success = predicate.evaluate(with: text)
        return success
    }
}
