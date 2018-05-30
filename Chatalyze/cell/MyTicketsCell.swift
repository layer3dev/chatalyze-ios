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
    var info:MyTicketsInfo?
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
    
    func fillInfo(info:MyTicketsInfo?){

        guard let info = info else{
            return
        }
        self.info = info
        self.chatnumberLbl?.text = info.chatNumber
        self.timeLbl?.text = info.startTime
        self.startDateLbl?.text = info.startDate
        self.title?.text = "Chat with \(info.eventTitle ?? "")"
    }
    
    @IBAction func jointEvent(send:UIButton){
        delegate?.jointEvent(info:self.info)
    }
}
