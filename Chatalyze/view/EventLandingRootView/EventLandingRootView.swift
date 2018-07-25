//
//  EventLandingRootView.swift
//  Chatalyze
//
//  Created by Mansa on 25/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


class EventLandingRootView:ExtendedView{

    @IBOutlet var hostnameLbl:UILabel?
    @IBOutlet var eventNameLbl:UILabel?
    @IBOutlet var costofEventLbl:UILabel?
    @IBOutlet var dateTimeLbl:UILabel?
    @IBOutlet var eventInfoLbl:UILabel?
    @IBOutlet var eventDetailInfo:UILabel?
    var iseventsold = false
    var info:EventInfo?
    var priceAttribute = [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 17)]
    var numberOfUnitAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "#8C9DA1"),NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 16)]
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func fillInfo(info:EventInfo?){
        
        Log.echo(key: "yud", text: "The current time zone ios \(Locale.current.identifier)\(Locale.current.regionCode)")
        
        guard let info = info else {
            return
        }
        isEventSoldOut()
        self.info = info
        hostnameLbl?.text = info.user?.firstName
        eventNameLbl?.text = info.title
        if let price = info.price{
            
            let firstStr = NSMutableAttributedString(string: "$\(price)", attributes: self.priceAttribute)
            
            let secondStr = NSMutableAttributedString(string: " per chat", attributes: numberOfUnitAttributes)
            
            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)
            costofEventLbl?.attributedText = requiredStr
        }
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EE, MMM dd yyyy"){
            self.dateTimeLbl?.text = startTime
        }
        
        eventInfoLbl?.text = "Private 1:1 video chats every \(info.duration ?? 0.0) mins from"
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm"){
            self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "") \(startTime)-"
           
            if let endTime = DateParser.convertDateToDesiredFormat(date: info.end, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "hh:mm"){
                self.eventInfoLbl?.text = "\(self.eventInfoLbl?.text ?? "")\(endTime) \(Locale.current.regionCode ?? "")"
            }
        }
        
        eventDetailInfo?.text = "Let's video chat 1:1 for \(info.duration ?? 0.0) mins on"

        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd"){
            self.eventDetailInfo?.text = "\(self.eventDetailInfo?.text ?? "") \(startTime)! Here's how:"
        }
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
                            //eventisSoldOut(status:true)
                            self.iseventsold = true
                        }else{
                            //eventisSoldOut(status: false)
                            self.iseventsold = false
                        }
                    }
                }
            }
        }
    }
//    func eventisSoldOut(status:Bool){
//
//        if status == true{
//            self.isUserInteractionEnabled = false
//        }else{
//            self.isUserInteractionEnabled = true
//        }
//    }
}
