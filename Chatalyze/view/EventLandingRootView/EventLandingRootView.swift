//
//  EventLandingRootView.swift
//  Chatalyze
//
//  Created by Mansa on 25/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//
import SwiftyJSON
import SDWebImage

class EventLandingRootView:ExtendedView{
    
    @IBOutlet var eventImage:UIImageView?
    @IBOutlet var hostnameLbl:UILabel?
    @IBOutlet var eventNameLbl:UILabel?
    @IBOutlet var costofEventLbl:UILabel?
    @IBOutlet var dateTimeLbl:UILabel?
    @IBOutlet var eventInfoLbl:UILabel?
    @IBOutlet var eventDetailInfo:UILabel?
    var iseventsold = false
    var info:EventInfo?
    var priceAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:UIFont(name: "Nunito-Regular-Regular", size: 17)]
    var numberOfUnitAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#8C9DA1"),NSAttributedString.Key.font:UIFont(name: "Nunito-Regular-Regular", size: 16)]
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    func fillInfo(info:EventInfo?){
        
        Log.echo(key: "yud", text: "The current time zone ios \(Locale.current.identifier)\(Locale.current.regionCode)")
        
        guard let info = info else {
            return
        }
        
        Log.echo(key: "yud", text: "Price is \(info.price)")
        
        self.info = info
        isEventSoldOut()
        hostnameLbl?.text = info.user?.firstName
        eventNameLbl?.text = info.title
        
        eventImage?.image = UIImage(named: "event_placeholder")
        
        if let url = URL(string: info.user?.profileImage ?? ""){
            SDWebImageManager.shared.loadImage(with: url, options: SDWebImageOptions.highPriority, progress: { (m, n, g) in
            }) { (image, data, error, chache, status, url) in
                if error == nil{
                    self.eventImage?.image = image
                }                
            }
        }
        if let price = info.price{

            costofEventLbl?.isHidden = false
            
            let firstStr = NSMutableAttributedString(string: "$ \(price)", attributes: self.priceAttribute as [NSAttributedString.Key : Any])

            let secondStr = NSMutableAttributedString(string: " per chat", attributes: numberOfUnitAttributes as [NSAttributedString.Key : Any])

            let requiredStr = NSMutableAttributedString()
            requiredStr.append(firstStr)
            requiredStr.append(secondStr)

            Log.echo(key: "yud", text: "price is requiered String \(requiredStr)")
            
            costofEventLbl?.attributedText = requiredStr
            
        }
        
//        else{
//            Log.echo(key: "yud", text: "price is requiered String false")
//            costofEventLbl?.isHidden = true
//        }
        
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
        
        if let callbooking = self.info?.callBookings{
            for info in callbooking{
                if let endDate = info["end"].string{
                    if let eventEndDate = self.info?.endDate{
                        
                        let requiredEndDate = DateParser.UTCStringToDate(endDate)
                        let differIs = requiredEndDate?.timeIntervalSince((eventEndDate))
                        if differIs == 0.0{
                           
                            self.iseventsold = true
                            return
                        }else{
                            self.iseventsold = false
                        }
                    }
                }
            }
        }
        self.iseventsold = false
        return

    }
}
