//
//  SavedCardsCell.swift
//  Chatalyze
//
//  Created by Mansa on 10/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SDWebImage

class SavedCardsCell: ExtendedTableCell {
    
    @IBOutlet var selectionImage:UIImageView?
    var info:CardInfo?
    @IBOutlet var saveCard:UIButton?
    @IBOutlet var cardField:SigninFieldView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface(){
        
        self.selectionStyle = .none
    }
    
    func fillInfo(info:CardInfo?,isSelected:Int){
        
        guard let info = info else{
            return
        }        
        self.info = info
        cardField?.textField?.placeholder = self.info?.lastDigitAccount
        if isSelected == 0{
            selectionImage?.image = UIImage(named: "untick")
        }else{
            selectionImage?.image = UIImage(named: "tick")
        }
    }
}
