//
//  EmptySlotsCells.swift
//  Chatalyze
//
//  Created by mansa infotech on 08/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class EmptySlotsCells:ExtendedCollectionCell {

    @IBOutlet var cellView:UIView?
    var info:EmptySlotInfo?
    @IBOutlet var startTimeLabel:UILabel?
    @IBOutlet var slotNumber:UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cellView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 5:3
        self.cellView?.layer.borderWidth = 1
        self.cellView?.layer.borderColor = UIColor(red: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1).cgColor
        self.cellView?.layer.masksToBounds = true
    }
    func fillInfo(info:EmptySlotInfo?,index:IndexPath){
        
        guard let info = info else {
            return
        }
        self.info = info
        if info.isSelected == false {
            self.cellView?.backgroundColor = UIColor.white
        }else{
            self.cellView?.backgroundColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1)
        }
        self.slotNumber?.text = "\(index.item+1)"
        
        if let date = self.info?.startDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let requireOne = dateFormatter.string(from: date)
            
            if let date = self.info?.endDate {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale.current
                dateFormatter.amSymbol = "am"
                dateFormatter.pmSymbol = "pm"
                self.startTimeLabel?.text = "\(requireOne) - \(dateFormatter.string(from: date))"
            }
        }
    }
}
