//
//  CheckInternetSpeed.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class CheckInternetSpeed: NSObject,URLSessionDelegate,URLSessionDataDelegate {
    
    
    var startTime: CFAbsoluteTime?
    var stopTime: CFAbsoluteTime?
    var bytesReceived: Int!
    var isItisFirstByteofData = true
    
    private var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: Error?) -> ())!
    
    
    var averageSpeedOnThreeTimes = 0.0
    var triedForInternet = 0
    
    func testDownloadSpeedWithTimeOut(timeOut:TimeInterval,completionHandler:@escaping ((_ megabytesPerSecond: Double?, _ error: Error?)->())){
        
        averageSpeedOnThreeTimes = 0.0
        startDownload()
        speedTestCompletionHandler = completionHandler
    }
    
    func startDownload(){
        
        guard let url = URL(string: AppConnectionConfig.systemTestUrl+"/images/sample_image_medium.jpg?version=\(Int.random(in: 0..<999999))") else{
            Log.echo(key: "yud", text: "url is incorrect")
            return
        }
        
        Log.echo(key: "yud", text: "image url is \(url)")
        stopTime = 0.0
        startTime = 0.0
        bytesReceived = 0
        isItisFirstByteofData = true
        
        //let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = 10.0
        let seesion = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        seesion.dataTask(with: url).resume()
    }
    
    
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if isItisFirstByteofData{
            startTime = CFAbsoluteTimeGetCurrent()
            isItisFirstByteofData = false
        }
        Log.echo(key: "yud", text: "data is \(data)")
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        Log.echo(key: "yud", text: "The start time is \(startTime)")
        Log.echo(key: "yud", text: "The EndTime is  \(stopTime)")
        
        let elapsed = (stopTime ?? 0.0) - (startTime ?? 0.0)
        Log.echo(key: "yud", text: "ElapseTime is \(elapsed)")
        Log.echo(key: "yud", text: "Recieved bytes are \(Double(bytesReceived))")
        Log.echo(key: "yud", text: "Speed is \(Double(bytesReceived) / elapsed / 1024.0 / 1024.0)")
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(bytesReceived))
        print("formatted result: \(string)")
        
        //        if error != nil{
        //            speedTestCompletionHandler(nil, error)
        //            return
        //        }
        
        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionHandler(nil,error)
            return
        }
        
        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        
        triedForInternet = triedForInternet + 1
        averageSpeedOnThreeTimes =  averageSpeedOnThreeTimes + speed
        Log.echo(key: "yud", text: "Tried chance is \(triedForInternet) and the average speed is \(averageSpeedOnThreeTimes)")
        if triedForInternet >= 2{
            //speedTestCompletionHandler((speed),nil)
            Log.echo(key: "yud", text: "I am returning with the speed stamp  \(averageSpeedOnThreeTimes/2.0)")
            speedTestCompletionHandler((averageSpeedOnThreeTimes/2.0),nil)
            return
        }
        startDownload()
    }
}
