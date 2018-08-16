//
//  AutographGalleryFlowLayout.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import UIKit

class EventQueueFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    
    override var itemSize: CGSize {
        
        set {            
        }
        get {
            return CGSize(width: 105, height: 81)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        sectionInset.top = 0
        sectionInset.bottom = 0
        sectionInset.left = 0
        sectionInset.right = 0
    }
}
