//
//  EventCell.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class EventCell: ExtendedTableCell {

    @IBOutlet var eventImage:UIImageView?
    @IBOutlet var evnetnameLbl:UILabel?
    @IBOutlet var eventtimeLbl:UILabel?
    @IBOutlet var borderView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
        
        self.selectionStyle = .none
        self.borderView?.layer.borderWidth = 2
        self.borderView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info else {
            return
        }
       
        eventImage?.image = UIImage(named: "base")
        if let url = URL(string: info.eventBannerUrl ?? ""){
            SDWebImageManager.shared().loadImage(with: url, options: SDWebImageOptions.highPriority, progress: { (m, n, g) in
            }) { (image, data, error, chache, status, url) in
                self.eventImage?.image = image
            }
        }
        
        eventImage?.load(withURL: info.eventBannerUrl, placeholder: UIImage(named:"base"))
        evnetnameLbl?.text = info.title
        eventtimeLbl?.text = info.start
        
        if let startTime = DateParser.convertDateToDesiredFormat(date: info.start, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EE, MMM dd h:mm"){
            
            self.eventtimeLbl?.text = startTime
            if let lastDate = DateParser.convertDateToDesiredFormat(date: info.end, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a"){
                self.eventtimeLbl?.text = "\(startTime) - \(lastDate)"
            }
        }
    }
}
