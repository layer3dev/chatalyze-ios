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
    
    @IBOutlet weak var hostName: UILabel?
    @IBOutlet weak var starTime: UILabel?
    
    func fillInfo(info:CustomTicketsInfo?){
        
        guard let info = info else{
            return
        }
        
        self.info = info
        self.hostName?.text = info.title
        self.starTime?.text = info.startTime
        
    }
    
}
