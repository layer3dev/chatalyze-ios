//
//  VerifyForEarlyCallProcessor.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class VerifyForEarlyCallProcessor: NSObject {
    
    var eventInfo:[EventInfo] = [EventInfo]()
    func verifyEarlyExistingCall(completion:@escaping (_ info:EventInfo?)->()) {
        
        guard let roleId = SignedUserInfo.sharedInstance?.role else{
            return
        }
        if roleId == .user{
            return
        }
        self.fetchInfo(completion: completion)
    }
    
    func fetchInfo(completion:@escaping (_ info:EventInfo?)->()){
        
        guard let id = SignedUserInfo.sharedInstance?.id else{
            return
        }

        FetchMySessionsProcessor().fetchInfo(id: id) { (success, info) in
            
            if success{
                if let array  = info {
                    if array.count > 0 {
                        for info in array {
                            if ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) < 3600 && ((info.startDate?.timeIntervalSince(Date()) ?? 0.0) >= 0)) {
                                completion(info)
                                return
                            }
                        }
                        completion(nil)
                    }
                }
            }
        }
    }    
}
