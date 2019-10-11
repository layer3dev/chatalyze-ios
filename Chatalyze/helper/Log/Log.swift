//
//  Log.swift
//  GGStaff
//
//  Created by Sumant Handa on 29/07/16.
//  Copyright © 2016 GenGold. All rights reserved.
//


import Foundation

@objc class Log : NSObject{
    
    @objc static func echo(key : String = "", text : Any? = ""){
        
        if(!DevFlag.debug){
            return
        }
        
        if(key != DevFlag.key && !DevFlag.showAll){
            return
        }
        
        guard let textEx = text
            else{
                print("\(key) -> nil")
                return
        }
        
        print("\(String(describing: DateParser.dateToStringInServerFormat(Date()))) \(key) -> \(textEx)")
    }
}
