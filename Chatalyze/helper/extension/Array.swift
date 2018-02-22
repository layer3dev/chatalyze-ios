//
//  Array.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 22/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation


public extension Array{
    
    func JSONDescription()->String{
        let array = self
        guard let JSONData: Data = try? JSONSerialization.data(withJSONObject: array, options: [])
            else{
                return ""
        }
        
        let str = String(data:JSONData , encoding: String.Encoding.utf8) ?? ""
        return str
    }
    
}
