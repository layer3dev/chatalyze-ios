//
//  AnalystPaymentHistoryCell.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AnalystPaymentHistoryCell: ExtendedTableCell {

    @IBOutlet var userIdLbl:UILabel?
    @IBOutlet var expectedPayoutAmount:UILabel?
    @IBOutlet var payoutDate:UILabel?
    @IBOutlet var createdDate:UILabel?
    
    var info:AnalystPaymentInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.selectionStyle = .none
    }
    
    func fillInfo(info:AnalystPaymentInfo?){
        
        guard let data = info else {
            return
        }
        self.userIdLbl?.text = data.id
        self.expectedPayoutAmount?.text = ("$")+(data.expectedPayoutAmount ?? "")
        self.setStartedDate()
    }
    func setStartedDate(){
        
        if let date = info?.createdDate {
            //Mar 7, 2019
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.createdDate?.text = "\(dateFormatter.string(from: date))"
        }
        if let date = info?.payoutDate {
            //Mar 7, 2019
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.payoutDate?.text = "\(dateFormatter.string(from: date))"
        }
        
        
    }
    
}
