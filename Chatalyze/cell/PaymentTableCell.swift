//
//  PaymentTableCell.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentTableCell: ExtendedTableCell {
    
    @IBOutlet var orderIdLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var amountLbl:UILabel?
    @IBOutlet var orderType:UILabel?
    @IBOutlet var cardView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
        cardView?.layer.cornerRadius = 5
        cardView?.layer.masksToBounds = true
        cardView?.layer.borderWidth = 1
        cardView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
    }
    
    func fillInfo(info:PaymentListingInfo?){
        
        guard let info = info  else {
            return
        }
        if let id = info.eventId{
           
            self.orderIdLbl?.text = "\(id)"
        }
        if let orderType = info.eventType{
           
            self.orderType?.text = "\(orderType)"
        }
        if let amount = info.amount{
            
            self.amountLbl?.text = "\(amount)"
        }
        if let date = info.paymentDate{
            
            self.dateLbl?.text = "\(date)"
        }
    }
}
