//
//  CustomTicketCell.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 06/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

class CustomTicketCell: ExtendedTableCell {

    
    var info:CustomTicketsInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    @IBOutlet weak var eventNameLbl : UILabel?
    @IBOutlet weak var hostNamelbl: UILabel?
    @IBOutlet weak var starTimeLbl: UILabel?
    @IBOutlet weak var ticketDiscriptionLbl : UILabel?
    @IBOutlet weak var claimBtnHight: NSLayoutConstraint?
    
    
    
    func fillInfo(info:CustomTicketsInfo?){
        
        guard let info = info else{
            return
        }
        
        self.info = info
        self.hostNamelbl?.text = info.title
        self.starTimeLbl?.text = info.startTime
        
    }
    
}
