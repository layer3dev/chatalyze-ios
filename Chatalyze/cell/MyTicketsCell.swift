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
    var info:SlotInfo?
    
        override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){

        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
    }
    
    func fillInfo(info:SlotInfo?){

        guard let info = info else{
            return
        }
        self.info = info
        self.chatnumberLbl?.text = String(info.slotNo ?? 0)
        self.timeLbl?.text = info.formattedStartTime
        self.startDateLbl?.text = info.formattedStartDate
        self.title?.text = "Chat with \(info.eventTitle ?? "")"
    }
    
    @IBAction func jointEvent(send:UIButton){
        
        delegate?.jointEvent(info:self.info)
    }
}
