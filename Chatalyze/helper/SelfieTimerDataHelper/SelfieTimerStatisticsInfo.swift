//
//  SelfieTimerStatisticsInfo.swift
//  Chatalyze
//
//  Created by Mansa on 12/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class SelfieTimerStatisticsInfo: NSCoding {
    
    //Local class Variables
    var isSelfieTimerInitiated:Bool = false
    var currentId = ""
    var isScreenShotSaved:Bool = false
    //End
    
    private static var _sharedInstance : SelfieTimerStatisticsInfo?
    static let encodingKey = "selfieTimerInfo"
    static var sharedInstance : SelfieTimerStatisticsInfo?{
        
        get{
            if(_sharedInstance != nil){
                return _sharedInstance
            }
            let instance = retreiveInstance()
            _sharedInstance = instance
            return instance
        }
    }
    
    private static func retreiveInstance()->SelfieTimerStatisticsInfo?{
        
        let ud = UserDefaults.standard
        guard let data = ud.object(forKey: encodingKey) as? Data
            else{
                return nil
        }
        let unarc = NSKeyedUnarchiver(forReadingWith: data)
        unarc.setClass(SelfieTimerStatisticsInfo.self, forClassName: "SelfieTimerStatisticsInfo")
        let selfieTimerInfo = unarc.decodeObject(forKey: "root") as? SelfieTimerStatisticsInfo
        return selfieTimerInfo
    }
    
    
    static func initSharedInstance()->SelfieTimerStatisticsInfo{
        
        //let oldInstance = sharedInstance
        let info = SelfieTimerStatisticsInfo()
        _sharedInstance = info
        info.save()
        return info
    }
    
    func save(){
        
        let ud = UserDefaults.standard
        let instance = self
        let data = NSKeyedArchiver.archivedData(withRootObject: instance)
        ud.set(data, forKey: SelfieTimerStatisticsInfo.encodingKey)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(currentId, forKey: "id")
        aCoder.encode(isScreenShotSaved, forKey: "isScreenShotSaved")
        aCoder.encode(isSelfieTimerInitiated, forKey: "isSelfieTimerInitiated")

    }
    
    required init?(coder aDecoder: NSCoder) {
       
        currentId = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        isScreenShotSaved = aDecoder.decodeObject(forKey: "isScreenShotSaved") as? Bool ?? false
        isSelfieTimerInitiated = aDecoder.decodeObject(forKey: "isSelfieTimerInitiated") as? Bool ?? false
    }
    
    init() {
    }
    
    func clear(){
        
        let ud = UserDefaults.standard
        ud.set(nil, forKey: SelfieTimerStatisticsInfo.encodingKey)
        ud.synchronize()
        SelfieTimerStatisticsInfo._sharedInstance = nil
    }
}

