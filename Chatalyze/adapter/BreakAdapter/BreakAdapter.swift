//
//  BreakAdapter.swift
//  Chatalyze
//
//  Created by mansa infotech on 12/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class BreakAdapter: ExtendedView {
    
    var customDelegate:InformForBreakSelectionInterface?
    
    @IBOutlet var breakCollection:UICollectionView?
    private let sectionInsets = UIEdgeInsets(top: 15.0,left: UIDevice.current.userInterfaceIdiom == .pad ? 15.0:8.0,bottom: 0.0,right: UIDevice.current.userInterfaceIdiom == .pad ? 15.0:8.0)
    let itemsPerRow = 4
    let screenSize = UIScreen.main.bounds
    var emptySlots = [EmptySlotInfo]()
    var root:EditSessionFormRootView?
    @IBOutlet var heightOfCollection:NSLayoutConstraint?
        
    override func layoutSubviews() {
        super.layoutSubviews()
       
        initialisation()
        updateHeightOfCell()
    }
    
    func initialisation(){
        
        self.breakCollection?.dataSource = self
        self.breakCollection?.delegate = self
        self.breakCollection?.reloadData()
    }
    
    func update(emptySlots:[EmptySlotInfo]?){
    
        guard let slots = emptySlots else{
            return
        }
        
        self.emptySlots = slots
        updateHeightOfCell()
        initialisation()
    }
    
    func updateHeightOfCell(){
        
        let cellCount = (Double(self.emptySlots.count)/4.0)
        let requiredHeightConstant = cellCount.rounded(.up)
        let heightOfCells = (CGFloat(requiredHeightConstant)*CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 60.0:45.0))
        let paddingSpace = (CGFloat(requiredHeightConstant+1)*sectionInsets.left)
        let totalHeightOfCollectionIs = heightOfCells+paddingSpace
        
        Log.echo(key: "yud", text: "Required Height Constraint is \(requiredHeightConstant) height of the cell is \(heightOfCells) total height of the collection is \(totalHeightOfCollectionIs)")
        
        Log.echo(key: "yud", text: "Collection height contraint is \(String(describing: heightOfCollection))")
        
        heightOfCollection?.constant = totalHeightOfCollectionIs
        self.layoutIfNeeded()
    }
}

extension BreakAdapter:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emptySlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptySlotsCells", for: indexPath) as? EmptySlotsCells else{
            return UICollectionViewCell()
        }
        
        if indexPath.item < self.emptySlots.count{
            
            cell.fillInfo(info: self.emptySlots[indexPath.item], index: indexPath)
        }
        
        return cell
    }
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //2
        let paddingSpace = (sectionInsets.left) * (CGFloat(itemsPerRow + 1))
        let availableWidth = (screenSize.width - (UIDevice.current.userInterfaceIdiom == .pad ? 60:30)) - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        Log.echo(key: "yud", text: "adding space is \(paddingSpace) available width is \(availableWidth) widthPerItem is \(widthPerItem)")
        return CGSize(width: widthPerItem-2, height: UIDevice.current.userInterfaceIdiom == .pad ? 60.0:45.0)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item < self.emptySlots.count{
            if self.emptySlots[indexPath.item].isSelected == false {
                
                self.emptySlots[indexPath.item].isSelected = true
                self.root?.emptySlotList[indexPath.item].isSelected = true
                root?.showSelectedIndex()
                customDelegate?.breakSelectionConfirmed()
                self.breakCollection?.reloadData()
                return
            }
            self.emptySlots[indexPath.item].isSelected = false
            self.root?.emptySlotList[indexPath.item].isSelected = false
            root?.showSelectedIndex()
            customDelegate?.breakSelectionConfirmed()
            self.breakCollection?.reloadData()
        }
    }
    
    var selectedBreakSlots:Int{
        get{
            var numberOfSlots = 0
            for info in self.emptySlots{
                if info.isSelected{
                    numberOfSlots = numberOfSlots + 1
                }
            }
            return numberOfSlots
        }
    }
}


