
//
//  HostCategoryListInfo.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class HostCategoryListInfo: NSObject {
    
    var id:String?
    var name:String?
    var categoryType:String?
    var categoryId:String?
    var selectedParamInfo:[String:Any]?
    
    override init(){
        super.init()
    }
    
    init(info:JSON?) {
        super.init()
        
        fillInfo(data:info)
    }
    
    func fillInfo(data:JSON?){
        
        guard let info = data?.dictionary else {
            return
        }
        self.id = info["id"]?.stringValue
        self.name = info["name"]?.stringValue
        self.categoryType = info["categoryType"]?.stringValue
        self.categoryId = info["categoryId"]?.stringValue
    }
}
