//
//  CheckInternetSpeed.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class CheckInternetSpeed: NSObject,URLSessionDelegate,URLSessionDataDelegate {

    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!
    var isItisFirstByteofData = true
    
    private var speedTestCompletionHandler: ((_ megabytesPerSecond: Double?, _ error: Error?) -> ())!
    
    func testDownloadSpeedWithTimeOut(timeOut:TimeInterval,completionHandler:@escaping ((_ megabytesPerSecond: Double?, _ error: Error?)->())){
        
       // https://dev.chatalyze.com/api/screenshots/50/url/chatalyze.png
        //"https://speed.hetzner.de/10GB.bin"
        
        guard let url = URL(string: "https://dev.chatalyze.com/images/small_image.jpg?version=1528457954337") else{
            Log.echo(key: "yud", text: "url is incorrect")
            return
        }
        
        stopTime = startTime
        bytesReceived = 0
        speedTestCompletionHandler = completionHandler
        
        //let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeOut
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
        
        let elapsed = stopTime - startTime
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
        speedTestCompletionHandler(speed,nil)
    }
}
