//
//  MyTicketsCell.swift
//  Chatalyze
//
//  Created by Mansa on 22/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class MyTicketsCell: ExtendedCollectionCell {

    @IBOutlet var mainView: UIView?
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
    
        override func viewDidLayout(){
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){

        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
    }
    
    func fillInfo(info:EventSlotInfo?){

        guard let info = info else{
            return
        }
        self.info = info
        self.chatnumberLbl?.text = String(info.slotNo ?? 0)
        initializeDesiredDatesFormat(info:info)
        self.title?.text = "Chat with \(info.eventTitle ?? "")"
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
        
        delegate?.jointEvent(info:self.info)
    }
    
    @IBAction func systemTest(sender:UIButton?){
        
        delegate?.systemTest()
    }
}
