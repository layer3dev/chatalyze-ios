//
//  MySessionTableViewCell.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MySessionTableViewCell: ExtendedTableCell {
    
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var ticketsBooked:UILabel?
    var info:EventInfo?
    var enterSession:(()->())?
    @IBOutlet var sessionEventButton:UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info  else {
            return
        }
        self.info = info
        if let title = info.title{
            
            self.title?.text = title
        }
        
        if let startDate = info.startDate{
            if let endDate = info.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                Log.echo(key: "yud", text: "The total time of the event is \(timeDiffrence)")
                if let durate  = info.duration{
                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
                    self.ticketsBooked?.text = "\(info.callBookings.count) of \(totalnumberofslots) "
                }
            }
        }
        setDate()
        paintEnterSession()
    }
    func paintEnterSession(){
        
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0{
            
            //Event is not started yet
            self.sessionEventButton?.backgroundColor = UIColor(red: 241.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1)
           self.sessionEventButton?.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
            return
        }
        self.sessionEventButton?.backgroundColor = UIColor(hexString: "#27B879")
        self.sessionEventButton?.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func setDate(){
        
        guard let info = self.info else{
            return
        }
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, MMM dd"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.dateLbl?.text = "\(dateFormatter.string(from: date)) \(Locale.current.regionCode ?? "")"
        }
        
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.timeLbl?.text = dateFormatter.string(from: date)
        }
    }
    
    
    @IBAction func enterSessionAction(sender:UIButton?){
        
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0{
         
            Log.echo(key: "yud", text: "You 'll be able to enter your session 30 minutes before it starts")
         
            RootControllerManager().getCurrentController()?.alert(withTitle: AppInfoConfig.appName, message: "You 'll be able to enter your session 30 minutes before it starts", successTitle: "OK", rejectTitle: "Cencel", showCancel: false, completion: { (success) in
                
            })
            return
        }
        if let session = enterSession{
            session()
        }
    }
}
