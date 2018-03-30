//
//  AutographyGalleryAdapter.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 21/12/16.
//  Copyright © 2016 Chatalyze. All rights reserved.
//

import Foundation
import UIKit


class EventQueueAdapter : NSObject{
    
    fileprivate var _infos : [SlotInfo] = [SlotInfo]()
}

extension EventQueueAdapter : UICollectionViewDelegate{
    
}

extension EventQueueAdapter : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "queue_cell", for: indexPath) as? CallQueueCell
            else{
                return CallQueueCell()
        }
        
        fillValues(cell: cell, indexPath: indexPath)
        return cell
    }
    
    fileprivate func fillValues(cell : CallQueueCell, indexPath : IndexPath){
        let index = (indexPath as NSIndexPath).row
        let info = infos[index]
        cell.fillInfo(index: index, slotInfo: info)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return _infos.count
    }
}

extension EventQueueAdapter{
    
    var infos :  [SlotInfo]{
        get{
            return _infos
        }
        
        set{
            _infos = newValue
        }
    }
}
