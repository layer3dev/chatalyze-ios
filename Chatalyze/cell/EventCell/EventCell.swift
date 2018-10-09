//
//  EventCell.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class EventCell: ExtendedTableCell {
    
    @IBOutlet var eventImage:UIImageView?
    @IBOutlet var evnetnameLbl:UILabel?
    @IBOutlet var eventtimeLbl:UILabel?
    @IBOutlet var borderView:UIView?
    var info:EventInfo?
    @IBOutlet var soldOutLabel:UILabel?

    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }

    func paintInterface(){
        
        self.selectionStyle = .none
        self.borderView?.layer.borderWidth = 2
        self.borderView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info else {
            return
        }
        
        self.info = info
        eventImage?.image = UIImage(named: "event_placeholder")
        if let url = URL(string: info.eventBannerUrl ?? ""){
            
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.highPriority, progress: { (m, n, g) in
            }) { (image, data, error, chache, status, url) in
                if error != nil{
                    self.eventImage?.image = image
                }
            }
        }
        
        //eventImage?.load(withURL: info.eventBannerUrl, placeholder: UIImage(named:"base"))
        evnetnameLbl?.text = info.title
        eventtimeLbl?.text = info.start
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EE, MMM dd h:mm"){
            
            self.eventtimeLbl?.text = startTime
            if let lastDate = DateParser.convertDateToDesiredFormat(date: info.end, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a"){
                self.eventtimeLbl?.text = "\(startTime) - \(lastDate)"
            }
        }
        isEventSoldOut()
    }
    
    func isEventSoldOut(){
    
        if let callbooking = self.info?.callBookings{
            for info in callbooking{
                if let endDate = info["end"].string{
                    if let eventEndDate = self.info?.endDate{
                     
                        let requiredEndDate = DateParser.UTCStringToDate(endDate)
                        let differIs = requiredEndDate?.timeIntervalSince((eventEndDate))
                        if differIs == 0.0{
                            eventisSoldOut(status:true)
                            return
                        }else{
                            eventisSoldOut(status:false)
                        }
                    }
                    //
                    //                    Log.echo(key: "yud", text: "Differ is \(differIs)")
                    //                    Log.echo(key: "yud", text: "End Date is slot \(endDate)")
                    //                    Log.echo(key: "yud", text: "End Date of event is  \(self.info?.endDate)")
                }
            }
        }
        eventisSoldOut(status:false)
        return
        
//        Log.echo(key: "yud", text: "Current Date is \(Date())")
//        if let startDate = self.info?.startDate{
//            if let endDate = self.info?.endDate{
//                let timeDiffrence = endDate.timeIntervalSince(startDate)
//                Log.echo(key: "yud", text: "The total time of the event is \(timeDiffrence)")
//                if let durate  = self.info?.duration{
//                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
//                    Log.echo(key: "yud", text: "The total time of slots are  \(totalnumberofslots)")
//                    Log.echo(key: "yud", text: "The number of the total callbookings are\(String(describing: self.info?.callBookings.count))")
//                    if let slotBooked = self.info?.callBookings.count{
//                        if slotBooked >= (totalnumberofslots+slotBooked){
//                            eventisSoldOut(status:true)
//                        }else{
//
//                            //Verifying the earlySlotBooked Scenario
//                            let currenToEndtimeDiffrence = endDate.timeIntervalSince(Date())
//                            let totalnumberofslots = Int(currenToEndtimeDiffrence/(durate*60))
//
//                            if !(slotBooked <= totalnumberofslots+slotBooked) {
//                                eventisSoldOut(status:true)
//                                return
//                            }
//                            eventisSoldOut(status: false)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func eventisSoldOut(status:Bool){
    
        if status == true{

            soldOutLabel?.isHidden = false
            //self.isUserInteractionEnabled = false
        }else{
            
            soldOutLabel?.isHidden = true
            //self.isUserInteractionEnabled = true
        }
    }
}
