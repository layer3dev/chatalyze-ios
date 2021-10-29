//
//  TwillioRoomInfo.swift
//  Chatalyze
//
//  Created by Yudhisther on 04/08/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation

class TwillioRoomInfo {
        
    var roomId:String?
    var identity:String?
    var token:String?
    var slotId:String?
    var isTokenFetching = false
    
    init(token:String?,roomId:String?,identity:String?,slotId:String?) {
        self.fillInfo(token:token,roomId:roomId,identity:identity,slotId:slotId)
    }
    
    private func fillInfo(token:String?,roomId:String?,identity:String?,slotId:String?){

        self.token = token
        self.roomId = roomId
        self.identity = identity
        self.slotId = slotId
    }
}
