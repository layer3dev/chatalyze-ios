//
//  MyTicketsController.swift
//  Chatalyze
//
//  Created by Mansa on 18/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

protocol getTicketsScrollInsets {
    
    func getTicketsScrollInset(scrollView:UIScrollView)
}

import UIKit

class MyTicketsController: InterfaceExtendedController {
    
    @IBOutlet var featureListingCollectionView:UICollectionView?
    var layout = UICollectionViewFlowLayout()
    
    @IBOutlet var scroll:UIScrollView?
    var delegate:getTicketsScrollInsets?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        featureListingCollectionView?.dataSource = self
        featureListingCollectionView?.delegate = self
        scroll?.delegate = self
        initializeCollectionFlowLayout()
    }
    
    func initializeCollectionFlowLayout(){
        
        let width = self.view.frame.size.width
        let height:CGFloat = 480
        let top = (self.view.frame.size.height-374.0)/2.0
        layout.itemSize = CGSize(width: width-60, height: 480)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0)
        
        //layout.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        featureListingCollectionView?.collectionViewLayout = layout
        featureListingCollectionView?.alwaysBounceVertical = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}

extension MyTicketsController:UICollectionViewDataSource{
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
            guard let cell = featureListingCollectionView?.dequeueReusableCell(withReuseIdentifier: "MyTicketsCell", for: indexPath) as? MyTicketsCell else{
                
                //Log.echo(key: "", text: "I enterd in nil cell")
                return UICollectionViewCell()
            }
        
            //Log.echo(key: "yudh", text: "Array in cellForRow is\(self.info.featuredActivity)")
        
           // cell.fillInfo(info: self.featureInfo[indexPath.row], index: indexPath.row)
        return cell
    }
}
extension MyTicketsController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MyTicketsController{
    
    class func instance()->MyTicketsController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTickets") as? MyTicketsController
        return controller
    }
}

extension MyTicketsController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.getTicketsScrollInset(scrollView: scrollView)
    }
}


