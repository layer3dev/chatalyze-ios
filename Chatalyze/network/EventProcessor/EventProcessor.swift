//
//  EventProcessor.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import Foundation
import SwiftyJSON
import Social
import Accounts

class EventProcessor{
    
    public func fetchInfo(id : String, completion : @escaping ((_ success : Bool, _ response : [EventInfo]?)->())){
        
        let newdate = DateParser.getMidNightDateTimeInString(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ssXXX")
        Log.echo(key: "yudh", text: "Date is \(Date())")
        let url = AppConnectionConfig.webServiceURL + "/schedules/calls/"
        var param:[String:Any] = [String:Any]()
        param["isTestAccount"] = false
        param["include"] = "callbookings"
        param["start"] = newdate
        //param["userId"] = id
//        Log.echo(key: "yud", text: "Url is \(url)")
//        Log.echo(key: "yud", text: "Param are  \(param)")
        ServerProcessor().request(.get,url,parameters: param,encoding: .queryString, authorize: true) { (success, response) in
            self.handleResponse(withSuccess: success, response: response, completion: completion)
        }
    }
    
    private func handleResponse(withSuccess success : Bool, response : JSON?, completion : @escaping ((_ success : Bool, _ response : [EventInfo]?)->())){
        
//        Log.echo(key: "yud", text: "Response of Fetch Info in the event Infos \(String(describing: response))")
//        Log.echo(key: "yud", text: "Value of the success is \(response?.description)")
        
        if(!success){
            completion(false, nil)
            return
        }
        guard let rawInfo = response?.arrayValue else{
            completion(false, nil)
            return
        }
        var eventArray:[EventInfo] = [EventInfo]()
        if rawInfo.count <= 0 {
            completion(true, eventArray)
            return
        }
        for info in rawInfo{
            let obj = EventInfo(info: info)
            eventArray.append(obj)
        }
        var runningEvent = [EventInfo]()
        for info in eventArray{
            if let currentDateInUTC = DateParser.getCurrentDateInUTC(){
                if let endDate = DateParser.getDateTimeInUTCFromWeb(dateInString:info.end,dateFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ"){
                    if currentDateInUTC.timeIntervalSince(endDate) < 0.0{
                        runningEvent.append(info)
                    }
                }
            }
        }        
        completion(true, runningEvent)
        return
    }
}

