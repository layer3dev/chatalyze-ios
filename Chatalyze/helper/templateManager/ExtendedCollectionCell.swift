//
//  ExtendedCollectionCell.swift
//  Chatalyze
//
//  Created by Sumant Handa on 30/03/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit

class ExtendedCollectionCell: UICollectionViewCell {
    
    private var isLoaded = false;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
