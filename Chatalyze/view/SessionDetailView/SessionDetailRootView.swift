//
//  SessionDetailRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

class SessionDetailRootView: ExtendedView {
    
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var ticketsBooked:UILabel?
    @IBOutlet var priceLbl:UILabel?
    @IBOutlet var durationLbl:UILabel?
    private var info:EventInfo?
    
    var controller :SessionDetailController?
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info  else {
            return
        }
        self.info = info
        if let title = info.title{
            
            self.title?.text = title
        }
        
        priceLbl?.text = "$\(info.price ?? 0.0) per chat"
        durationLbl?.text = "\(info.duration ?? 0) min chat"
        
        if let startDate = info.startDate{
            if let endDate = info.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                Log.echo(key: "yud", text: "The total time of the session is \(timeDiffrence)")
                if let durate  = info.duration{
                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
                    self.ticketsBooked?.text = "\(info.callBookings.count) of \(totalnumberofslots) chats booked "
                }
            }
        }
        setDate()
    }

    func setDate(){
        
        guard let info = self.info else{
            return
        }
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.dateLbl?.text = "\(dateFormatter.string(from: date))"
        }
        
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let requireOne = dateFormatter.string(from: date)
            
            if let date = info.endDate{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale.current
                self.timeLbl?.text = "\(requireOne) - \(dateFormatter.string(from: date)) \(TimeZone.current.abbreviation() ?? "")"
                
                Log.echo(key: "yud", text: "Locale abbrvation sis ")
            }
        }
        
    }
    
    @IBAction func menuAction(sender:UIButton){
    
        self.controller?.menuAction()
    }
    
    
    @IBAction func backButton(sender:UIButton){
        
        self.controller?.backAction()
    }
    
    
}
