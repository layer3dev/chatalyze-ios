//
//  GreetingCell.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class GreetingCell: ExtendedTableCell {
    
    @IBOutlet var greetingImage:UIImageView?
    @IBOutlet var username:UILabel?
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
    
    func fillInfo(info:GreetingInfo?){
        
        guard let info = info else {
            return
        }
       //greetingImage?.load(withURL: info.greetingImageUrl, placeholder: UIImage(named:"base"))
        greetingImage?.image = UIImage(named:"base")
        if let imageStr = info.greetingImageUrl{
            
            greetingImage?.sd_setImage(with: URL(string:imageStr), placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
            })
        }
        username?.text = info.name
    }
}

