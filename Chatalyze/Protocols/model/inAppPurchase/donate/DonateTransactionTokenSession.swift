//
//  TransactionTokenSession.swift
//  Chatalyze
//
//  Created by Sumant Handa on 19/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class DonateTransactionTokenSession{
    
    private static var _sharedInstance : DonateTransactionTokenSession?
    
    var token : String?
    
    private static let suiteHash = "com.chatalyze.donate"
    
    let storeDefault = UserDefaults(suiteName: DonateTransactionTokenSession.suiteHash)
    
    static var sharedInstance : DonateTransactionTokenSession?{
        get{
            if(_sharedInstance != nil){
                return _sharedInstance
            }
            let instance = DonateTransactionTokenSession()
            instance.retreive()
            let token = instance.token
            if(token == nil){
                return nil
            }
            _sharedInstance = instance
            return instance
        }
    }
    
    static func initSharedInstance(token : String?)->DonateTransactionTokenSession{
        
        let info = DonateTransactionTokenSession(token : token)
        _sharedInstance = info
        info.save()
        return info
    }
    
    init(){
        
    }
    
    init(token : String?){
        
        self.token = token
        save()
    }
    
    
    
    private func retreive(){
        guard let storeDefault = storeDefault
            else{
                return
        }
        
        token = storeDefault.string(forKey: "token")
    }
    
    
    func save() {
        guard let storeDefault = storeDefault
            else{
                return
        }
        storeDefault.set(token, forKey: "token")

        
    }
    
    func clear(){
        
        if let storeDefault = storeDefault{
           
            storeDefault.removePersistentDomain(forName: DonateTransactionTokenSession.suiteHash)
            storeDefault.synchronize()
        }        
        DonateTransactionTokenSession._sharedInstance = nil
    }
}



