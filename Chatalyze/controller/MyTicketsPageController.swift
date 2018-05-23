//
//  MyTicketsPageController.swift
//  Chatalyze
//
//  Created by Mansa on 23/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsPageController: MyTicketsController {

    @IBOutlet var rootView:MyTicketsPageRootView?    
 
    override func viewDidLayout() {
        super.viewDidLayout()
      
        paintInterface()
        initializeVariable()
    }
    
    override func paintInterface(){
        
        paintNavigationTitle(text: "My Tickets")
    }
    
   override func initializeVariable(){
        
        //rootView?.controller = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initializeCollectionFlowLayout(){
        
        Log.echo(key: "yud", text: "feature Height is \(featureHeight)")
        
        self.featureListingCollectionView?.layoutIfNeeded()
        featureListingCollectionView?.dataSource = self
        featureListingCollectionView?.delegate = self
        let width = self.view.frame.size.width
        
        layout.itemSize = CGSize(width: width-60, height: featureHeight-15)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0)
        
        //layout.sectionInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        featureListingCollectionView?.collectionViewLayout = layout
        featureListingCollectionView?.alwaysBounceVertical = false
        self.featureListingCollectionView?.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override class func instance()->MyTicketsPageController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsPage") as? MyTicketsPageController
        return controller
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

