//
//  MyTicketsCell.swift
//  Chatalyze
//
//  Created by Mansa on 22/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

import UIKit
import SDWebImage

class MyTicketsCell: ExtendedCollectionCell {

    override func viewDidLayout() {
        super.viewDidLayout()
        
       
       // painInterface()
    }
    
//    func painInterface(){
//
//        self.selectionStyle = .none
//        cardView?.layer.cornerRadius = 5
//        cardView?.layer.masksToBounds = true
//        cardView?.layer.borderWidth = 1
//        cardView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
//    }
    
//    func fillInfo(info:MemoriesInfo?){
//
//        guard let info = info else{
//            return
//        }
//        memoryImage?.image = UIImage(named: "base")
//        if let imageStr = info.screenShotUrl{
//            if let url = URL(string: imageStr){
//                memoryImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
//                })
//            }
//        }
//    }
    
}
