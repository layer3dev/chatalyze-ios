//
//  UserSocketRegistrationTimeout.swift
//  Chatalyze
//
//  Created by Sumant Handa on 02/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class UserSocketRegistrationTimeout{
    
    var listener : (()->())?
    var isCancelled = false
    var identifier = 0
    
    
    func registerForTimeout(seconds : Double, listener : @escaping (()->())){
        
        //we're using identifier to ignore previous timeouts
        let localIdentifier = identifier + 1
        
        self.identifier = localIdentifier
        self.listener = listener
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let weakSelf = self
                else{
                    return
            }
            
            //this is old identifier callback - so ignore it
            if(localIdentifier != weakSelf.identifier){
                return
            }
            
            weakSelf.listener?()
        }
    }
    
    func cancelTimeout(){
        listener = nil
    }
    
    
    
}
