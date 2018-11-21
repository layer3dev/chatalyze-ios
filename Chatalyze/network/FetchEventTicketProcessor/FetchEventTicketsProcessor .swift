//
//  FetchEventTicketsProcessor .swift
//  Chatalyze
//
//  Created by Mansa on 24/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON


class FetchEventTicketsProcessor{
    
    public func fetchInfo(id : String, completion : @escaping ((_ success : Bool, _ response : [SlotInfo]?)->())){
        
        let newdate = DateParser.getMidNightDateTimeInString(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ssXXX")
        Log.echo(key: "yudh", text: "Date is \(Date())")
        let url = AppConnectionConfig.webServiceURL + "/bookings/calls/pagination/"
        var param:[String:Any] = [String:Any]()
        
        param["start"] = newdate
        param["limit"] = 1000
        param["offset"] = 0
        param["removePrevious"] = true
        param["userId"] = id
        
        //param["userId"] = id
        Log.echo(key: "yud", text: "Url is \(url)")
        Log.echo(key: "yud", text: "Param are  \(param)")

        ServerProcessor().request(.get,url,parameters: param,encoding: .queryString, authorize: true) { (success, response) in
            
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [SlotInfo]?)->())){
        
//        Log.echo(key: "yud", text: "Resonse of Fetch Info in Login Page\(String(describing: response))")
//        Log.echo(key: "yud", text: "Value of the success is \(response?.description)")
        
        Log.echo(key: "yud", text: "Response in mY tickets is \(response)")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
       
        var slotInfo:[SlotInfo] = [SlotInfo]()
        if rawInfo.count <= 0 {
            completion(true,slotInfo)
            return
        }
        for info in rawInfo{
            
            let slotobj = SlotInfo(info: info)
            if slotobj.slotNo != nil{
                slotInfo.append(slotobj)
            }
        }
        completion(true,slotInfo)
        return
    }
}

