//
//  MyTicketsVerticalCell.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import SDWebImage

class MyTicketsVerticalCell: ExtendedTableCell {
    
    @IBOutlet var borderView:UIView?
    @IBOutlet var chatnumberLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var startDateLbl:UILabel?
    @IBOutlet var title:UILabel?
    var delegate:MyTicketCellDelegate?
    var info:EventSlotInfo?
    
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    
    @IBOutlet var joinButtonContainer:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
                
        self.separatorInset.bottom = 20
        self.selectionStyle = .none
        self.borderView?.layer.borderWidth = 4
        self.borderView?.layer.borderColor = UIColor(red: 241.0/255.0, green: 244.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor
        self.joinButtonContainer?.layer.cornerRadius = 5
        self.joinButtonContainer?.layer.masksToBounds = true
    }
    
    
    func fillInfo(info:EventSlotInfo?){
        
        guard let info = info else{
            return
        }
        self.info = info
        self.chatnumberLbl?.text = String(info.slotNo ?? 0)
        initializeDesiredDatesFormat(info:info)
//      self.title?.text = "Chat with \(info.eventTitle ?? "")"
        self.title?.text = "\(info.eventTitle ?? "")"
    }
    
    func initializeDesiredDatesFormat(info:EventSlotInfo){
        
        _formattedEndTime = info.end
        _formattedStartTime = info.start
        self.timeLbl?.text = self.formattedStartTime
        self.startDateLbl?.text = self.formattedStartDate
    }
    
    
    var _formattedStartTime:String?{
        
        get{
            return formattedStartTime ?? ""
        }
        set{
            
            let date = newValue
            
            formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
            
            formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MMM dd, yyyy")
            
            formattedStartTime = "\(formattedStartTime ?? "")-\(formattedEndTime ?? "")"
        }
    }
    
    var _formattedEndTime:String?{
        
        get{
            
            return formattedEndTime ?? ""
        }
        set{
            
            let date = newValue
            formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
        }
    }
    
    
    
    @IBAction func jointEvent(send:UIButton?){
        
        Log.echo(key: "yud", text: "Joint Event is calling!!")        
        delegate?.jointEvent(info:self.info)
    }
    
    @IBAction func systemTest(sender:UIButton?){
        
        delegate?.systemTest()
    }
}
