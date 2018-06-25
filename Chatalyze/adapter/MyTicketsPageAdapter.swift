
//
//  MyTicketsPageAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 24/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class MyTicketsPageAdapter: MyTicketesAdapter {

    override func initializeCollectionFlowLayout(){
        
        Log.echo(key: "yud", text: "feature Height is\(featureHeight)")        
        self.myTicketsCollectionView?.layoutIfNeeded()
        self.myTicketsCollectionView?.dataSource = self
        self.myTicketsCollectionView?.delegate = self
        let width = root?.superview?.frame.size.width ?? 60.0
        layout.itemSize = CGSize(width: width-60, height: featureHeight-15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0)
        //layout.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        self.myTicketsCollectionView?.collectionViewLayout = layout
        self.myTicketsCollectionView?.alwaysBounceVertical = false
        self.myTicketsCollectionView?.reloadData()
    }
}