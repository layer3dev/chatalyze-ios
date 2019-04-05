//
//  ExtendedTableCell.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 28/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit

class ExtendedTableCell: UITableViewCell {

     var isLoaded = false
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        if(!isLoaded){
            isLoaded = true
            viewDidLayout()
        }
    }
    
    func viewDidLayout(){
    }
}
