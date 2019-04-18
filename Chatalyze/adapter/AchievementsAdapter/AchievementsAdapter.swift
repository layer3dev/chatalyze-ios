//
//  AchievementsAdapter.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AchievementsAdapter: ExtendedView {

    @IBOutlet var achievementCollection:UICollectionView?
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: UIDevice.current.userInterfaceIdiom == .pad ? 15.0:10.0,bottom: 30.0,right: UIDevice.current.userInterfaceIdiom == .pad ? 15.0:10.0)
    var itemsPerRow:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4:3
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initialize()
    }
    
    func initialize(){
       
        self.achievementCollection?.dataSource = self
        self.achievementCollection?.delegate = self
        self.achievementCollection?.reloadData()
    }
}

extension AchievementsAdapter:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementsCollectionCell", for: indexPath) as? AchievementsCollectionCell else{
            return UICollectionViewCell()
        }
        return cell
    }
}

extension AchievementsAdapter:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension AchievementsAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 40.0:30.0
    }
}
