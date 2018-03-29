
//
//  PeerInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 29/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON

class PeerInfo: NSObject {
    var id : Int?
    var name : String?
    var type : String?
    var room : String?
    var data : PeerMetaInfo?
    var isBroadcasting : Bool?
    
    
    override init(){
        super.init()
    }
    
    init(info : JSON?){
        super.init()
        fillInfo(info: info)
    }
    
    func fillInfo(info : JSON?) {
        guard let json = info
            else{
                return
        }
        id = json["id"].int
        name = json["name"].string
        type = json["type"].string
        room = json["room"].string
        isBroadcasting = json["isBroadcasting"].bool
        
        data = PeerMetaInfo(info : json["data"])
    }
}
