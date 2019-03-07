//
//  HostCategoryCell.swift
//  Chatalyze
//
//  Created by mansa infotech on 21/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//




import Foundation
import UIKit

class HostCategoryCell: ExtendedTableCell {

    @IBOutlet var name:UILabel?
    var info:HostCategoryListInfo?
    var selectedIndex:((Int)->())?
    var currentIndex:Int = 0
    var isCellSelected:Bool = false
    @IBOutlet var selectionView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.selectionStyle = .none
    }
    
    @IBAction func buttonAction(sender:UIButton){
        selectedIndex?(currentIndex)
    }

    func fillInfo(info:HostCategoryListInfo?){

        guard let info = info else{
            return
        }
        self.name?.text = info.name?.firstCapitalized
        if isCellSelected{
            
            selectionView?.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        }else{
            
            selectionView?.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
}




