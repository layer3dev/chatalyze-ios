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
    var bytesReceived: Int = 0
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
            //Log.echo(key: "yud", text: "url is incorrect")
            return
        }
        
        Log.echo(key: "yud", text: "image url is \(url)")
        stopTime = 0.0
        startTime = 0.0
        bytesReceived = 0
        isItisFirstByteofData = true
        
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = 40.0
        let seesion = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        seesion.dataTask(with: url).resume()
    }
    
    
    internal func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if isItisFirstByteofData{
            startTime = CFAbsoluteTimeGetCurrent()
            isItisFirstByteofData = false
        }
        
        bytesReceived += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error != nil{
            speedTestCompletionHandler(nil,error)
            return
        }
        
        
        let elapsed = (stopTime ?? 0.0) - (startTime ?? 0.0)
        
        Log.echo(key: "speed_logging", text: "ElapseTime is \(elapsed)")
        Log.echo(key: "speed_logging", text: "Recieved bytes are \(Double(bytesReceived))")
        
        
        let speed = Double(bytesReceived * 8) / elapsed / 1024.0 / 1024.0
        Log.echo(key: "speed_logging", text: "speed is \(speed)")
        
        triedForInternet = triedForInternet + 1
        
        averageSpeedOnThreeTimes =  averageSpeedOnThreeTimes + speed
        
        
        
        if(triedForInternet < 2){
            startDownload()
            return
        }
        let averageSpeed = averageSpeedOnThreeTimes/2.0
        let roundedAverageSpeed = averageSpeed.roundTo(places: 2)
        
        
        Log.echo(key: "speed_logging", text: "averageSpeed is \(averageSpeed)")
        Log.echo(key: "speed_logging", text: "roundedAverageSpeed is \(roundedAverageSpeed)")
        
        speedTestCompletionHandler(roundedAverageSpeed,nil)
    }
    
}
