//
//  ExtensionString.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 06/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation

let LanguageKey = "LanguageKey"

extension String {
    func localized() -> String? {
        
        
        var defaultLanguage = "en"
        
//        if let selectedLanguage = UserDefaults.standard.string(forKey: LanguageKey){
//            defaultLanguage = selectedLanguage
//        }
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
