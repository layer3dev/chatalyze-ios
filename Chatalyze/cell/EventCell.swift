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
        eventImage?.image = UIImage(named: "chatalyze_logo")
        if let url = URL(string: info.eventBannerUrl ?? ""){
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.highPriority, progress: { (m, n, g) in
            }) { (image, data, error, chache, status, url) in
                self.eventImage?.image = image
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
    
        Log.echo(key: "yud", text: "Yes I am calling")
        if let startDate = self.info?.startDate{
            if let endDate = self.info?.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                Log.echo(key: "yud", text: "The total time of the event is \(timeDiffrence)")
                if let durate  = self.info?.duration{
                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
                    Log.echo(key: "yud", text: "The total time of slots are  \(totalnumberofslots)")
                    Log.echo(key: "yud", text: "The number of the total callbookings are\(String(describing: self.info?.callBookings.count))")
                    if let slotBooked = self.info?.callBookings.count{
                        if slotBooked >= totalnumberofslots{
                            eventisSoldOut(status:true)
                        }else{
                            eventisSoldOut(status: false)
                        }
                    }
                }
            }
        }
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
