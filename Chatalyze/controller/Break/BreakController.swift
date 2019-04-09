//
//  BreakController.swift
//  Chatalyze
//
//  Created by mansa infotech on 08/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class BreakController: UIViewController {

    @IBOutlet var breakCollection:UICollectionView?
    @IBOutlet var heightOfCollectionViewConstraint:NSLayoutConstraint?
    private let sectionInsets = UIEdgeInsets(top: 0.0,left: 10.0,bottom: 0.0,right: 10.0)
    let itemsPerRow = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialisation()
        // Do any additional setup after loading the view.
    }
    
    func initialisation(){
        
        self.breakCollection?.dataSource = self
        self.breakCollection?.delegate = self
        self.breakCollection?.reloadData()
        
        let heightOfCells = ceil(((30.0/4.0)*60.0))
        let heightOfSpaces = ((30.0/4.0)*10)+15.0
        let totalHeight = heightOfCells+heightOfSpaces
        
        self.heightOfCollectionViewConstraint?.constant = CGFloat(totalHeight)
    }
    
    class func instance()->BreakController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSessionSinglePage", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BreakController") as? BreakController
        return controller
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BreakController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptySlotsCells", for: indexPath) as? EmptySlotsCells else{
            return UICollectionViewCell()
        }
        return cell
    }
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //2
        let paddingSpace = (sectionInsets.left) * (CGFloat(itemsPerRow + 1))
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: 60.0)
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
    
    
}


