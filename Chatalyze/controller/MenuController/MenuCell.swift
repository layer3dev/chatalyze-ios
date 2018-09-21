//
//  MenuCell.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class MenuCell: ExtendedTableCell {
    
    @IBOutlet var userImage:UIImageView?
    var info:MenuInfo?
   @IBOutlet var optionName:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
    }
    
    func fillInfo(info:MenuInfo?){
        
        guard let info = info else{
            return
        }
        self.info = info
        userImage?.image = UIImage(named: "base")
//        if let imageStr = info.screenShotUrl{
//            if let url = URL(string: imageStr){
//                memoryImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
//                })
//            }
//        }
    }
}

