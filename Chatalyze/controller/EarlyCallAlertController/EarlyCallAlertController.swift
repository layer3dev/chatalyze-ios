//
//  EarlyCallAlertController.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class EarlyCallAlertController: InterfaceExtendedController {

    var requiredDate:Date?
    var info:EventInfo?
    var timer = Timer()
    @IBOutlet var minutes:UILabel?
    @IBOutlet var seconds:UILabel?
    @IBOutlet var name:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.startTimer()
        self.fillInfo()
    }
    
    func fillInfo(){
        
        self.name?.text = info?.title
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.timer.invalidate()
    }
    
    func startTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRepeat), userInfo: nil, repeats: true)
    }
    
    @objc func timerRepeat(){
        
        let (hour,minute,second) = countdownTimeFromNow(requiredDate: self.requiredDate) ?? ("","","")
        self.minutes?.text = minute
        self.seconds?.text = second
        
        Log.echo(key: "yud", text: "hour is \(hour) minute is \(minute) second is \(second)")
    }
    
    func countdownTimeFromNow(requiredDate:Date?)->( hours : String, minutes : String, seconds : String)?{
        
        guard let date = requiredDate else{
            return ("","","")
        }
        let totalSeconds = Int(date.timeIntervalTillNow)
        //print("logging", "total seconds ->  \(totalSeconds)")
        if totalSeconds > 3600 || totalSeconds < 0{
            self.dismiss(animated: true) {
            }
            return("0","0","0")
        }
        let hours = (totalSeconds) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        
        let hourString = String(format: "%02d", hours)
        let minuteString = String(format: "%02d", minutes)
        let secondString = String(format: "%02d", seconds)        
        return ( hourString, minuteString, secondString)
    }
    
    @IBAction func enterCallRoom(sender:UIButton?){
     
        guard let currentPresentingController = self.presentingViewController else{
            return
        }
        
        self.dismiss(animated: true) {
            
            guard let controller = HostCallController.instance()
                else{
                    return
            }
            controller.eventId = String(self.info?.id ?? 0)
            Log.echo(key: "yud", text: "controller present is \(currentPresentingController)")
            currentPresentingController.present(controller, animated: true, completion: nil)
        }
    }
}

extension EarlyCallAlertController{
    
    class func instance()->EarlyCallAlertController?{
        
        let storyboard = UIStoryboard(name: "EarlyEventAlert", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EarlyCallAlert") as? EarlyCallAlertController
        return controller
    }
}
