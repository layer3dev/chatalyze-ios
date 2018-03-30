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
            let numberOfColumns: CGFloat = 3
            
            let itemWidth = (self.collectionView!.frame.width - (64)) / numberOfColumns
            return CGSize(width: itemWidth, height: 280)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 16
        minimumLineSpacing = 16
        scrollDirection = .vertical
        sectionInset.top = 16
        sectionInset.bottom = 16
        sectionInset.left = 16
        sectionInset.right = 16
    }
}
