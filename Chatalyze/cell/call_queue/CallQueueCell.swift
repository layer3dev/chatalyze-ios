//
//  CallQueueCell.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit
import ImageLoader

class CallQueueCell: ExtendedCollectionCell {
    
    fileprivate var index : Int?
    fileprivate var slotInfo : SlotInfo?
    @IBOutlet private var queueNumberLabel : UILabel?
    @IBOutlet private var countdownLabel : UILabel?
    
    public func fillInfo(index : Int, slotInfo : SlotInfo?){
        self.slotInfo = slotInfo
        self.index = index
        fillInterface()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
    }
    
    private func fillInterface(){
        queueNumberLabel?.text = "\((slotInfo?.slotNo ?? 0))"
        
        guard let slotInfo = slotInfo
            else{
                return
        }
        guard let startDate = slotInfo.startDate
            else{
                return
        }
        
        
        guard let countdownInfo = startDate.countdownTimeFromNow()
            else{
                return
        }
        
        let countdownTime = "\(countdownInfo.minutes) : \(countdownInfo.seconds)"
    }
}



