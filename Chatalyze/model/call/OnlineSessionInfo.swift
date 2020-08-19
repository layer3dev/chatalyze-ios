//
//  OnlineSessionInfo.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 06/11/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class OnlineUserListInfo: NSObject {
    
    var onlineUsers:[Int] = [Int]()
    var leftUserId:Int?
    
    
    override init() {
        super.init()
    }
    
    init(info: [[String:Any]]?) {
        super.init()
        
        self.fillInfo(info: info)
    }
    
    func fillInfo(info:[[String:Any]]?){
        
        guard let data = info else{
            return
        }
        
        if data.count <=  0{
            return
        }
        guard let dataInfo = info?[0] else{
            return
        }
        guard let onlineUserList = dataInfo["onlineUsers"] as? [Int] else{
            
            Log.echo(key: "yud", text: "User left the room having the data \(dataInfo)")
            let leftUserId = dataInfo["leftUserId"] as? Int
            
            Log.echo(key: "yud", text: "User left the room having the data \(dataInfo) and the left user id is \(String(describing: leftUserId))")

            self.leftUserId = leftUserId

            return
        }
        
        Log.echo(key: "yud", text: "online user list is \(onlineUserList)")
        
        for info in onlineUserList{
            onlineUsers.append(info)
        }
    }
    
        
}
