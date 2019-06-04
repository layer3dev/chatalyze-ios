//
//  PaymentSetupPaypalRootView.swift
//  Chatalyze
//
//  Created by Mansa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class PaymentSetupPaypalRootView:ExtendedView{

    var controller:PaymentSetupPaypalController?
    @IBOutlet var pendingAmountLbl:UILabel?
    @IBOutlet var ticketSalesAmount:UILabel?
    @IBOutlet var tipAmount:UILabel?
    let amount = "$"
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        //controller?.
    }
    
    func fillBiilingInfo(info:BillingInfo?){
        
        pendingAmountLbl?.text = (self.amount)+(info?.pendingAmount ?? "")
        ticketSalesAmount?.text = (self.amount)+(info?.earnedAmount ?? "")
        tipAmount?.text = (self.amount)+(info?.tipAmount ?? "")
    }
}
