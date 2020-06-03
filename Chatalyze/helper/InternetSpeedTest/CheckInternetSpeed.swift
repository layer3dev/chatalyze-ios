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
    var bytesReceived: Int64 = 0
    var isItisFirstByteofData = true
    
    private var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: Error?) -> ())?
    
    var averageSpeedOnThreeTimes = 0.0
    var triedForInternet = 0
    
    func testDownloadSpeedWithTimeOut(timeOut:TimeInterval,completionHandler:@escaping ((_ megabytesPerSecond: Double?, _ error: Error?)->())){
        
        averageSpeedOnThreeTimes = 0.0
        startDownload()
        speedTestCompletionHandler = completionHandler
    }
    
    private func startDownload(){
        
        guard let url = URL(string: AppConnectionConfig.speedTestURL+"?version=\(Int.random(in: 0..<999999))") else{
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
        
        bytesReceived += Int64(data.count)
        stopTime = CFAbsoluteTimeGetCurrent()
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
//        if error != nil{
//            speedTestCompletionHandler?(nil,error)
//            return
//        }
//
//        let elapsed = (stopTime ?? 0.0) - (startTime ?? 0.0)
//
//        Log.echo(key: "speed_logging", text: "ElapseTime is \(elapsed)")
//        Log.echo(key: "speed_logging", text: "Recieved bytes are \(Double(bytesReceived))")
//
//        let speed = Double(bytesReceived * 8) / elapsed / 1024.0 / 1024.0
//        Log.echo(key: "speed_logging", text: "speed is \(speed)")
//
//
//        speedTestCompletionHandler?(speed,nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        
        Log.echo(key : "speed", text : "metrics \(metrics.transactionMetrics.count)")
        Log.echo(key : "speed", text : "metrics \(metrics.transactionMetrics.first)")
        
        guard let transactionMetrics = metrics.transactionMetrics.first
            else{
                return
        }
        
        guard let endTime = transactionMetrics.responseEndDate?.timeIntervalSince1970, let startTime = transactionMetrics.responseStartDate?.timeIntervalSince1970
            else{
                speedTestCompletionHandler?(nil,nil)
                return
        }

        let elapsed = endTime - startTime

        Log.echo(key: "speed_logging", text: "ElapseTime is \(elapsed)")
        Log.echo(key: "speed_logging", text: "Recieved bytes are \(Double(bytesReceived))")

        let speed = Double(bytesReceived * 8) / elapsed / 1024.0 / 1024.0
        Log.echo(key: "speed_logging", text: "speed is \(speed)")
        speedTestCompletionHandler?(speed,nil)
    }
    
    
 
    
}
