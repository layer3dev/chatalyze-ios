//
//  SessionDetailTableCell.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionDetailTableCell: ExtendedTableCell {
    
    var isBreak = false
    @IBOutlet var attendessNameLbl:UILabel?
    @IBOutlet var slotTime:UILabel?
    var emptySlotInfo:EmptySlotInfo?
    var index:Int?
    
    override func viewDidLayout() {
        super.viewDidLayout()
     
        self.selectionStyle = .none
    }
    
    func fillInfo(info:EmptySlotInfo?,index:Int?){
        
        guard let info = info else {
            return
        }
        
        self.emptySlotInfo = info
        self.index = index
                
        if isBreak {
            
            self.attendessNameLbl?.text = "\((self.index ?? 0)+1).  Break"
        }else{
          
            self.attendessNameLbl?.text = "\((self.index ?? 0)+1).  \(self.emptySlotInfo?.slotInfo?.user?.firstName?.firstCapitalized ?? "")"
        }
        
        if let date = self.emptySlotInfo?.startDate {
            
            let dateFormatter = DateFormatter()
            if Locale.current.languageCode == "en"{
                dateFormatter.dateFormat = "h:mm:ss"
            }else{
                dateFormatter.dateFormat = "H:mm"
            }

            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let requireOne = dateFormatter.string(from: date)
            
            if let date = self.emptySlotInfo?.endDate{
                
                let dateFormatter = DateFormatter()
                if Locale.current.languageCode == "en"{
                    dateFormatter.dateFormat = "h:mm:ss a"
                    dateFormatter.amSymbol = "AM"
                    dateFormatter.pmSymbol = "PM"
                }else{
                    dateFormatter.dateFormat = "H:mm"
                }
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale.current
              
                self.slotTime?.text = "\(requireOne) - \(dateFormatter.string(from: date))"
            }
        }
    }
}


