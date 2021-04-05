//
//  CustomTicketsAdapter.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 05/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class CustomTicketsAdapter: ExtendedView {
    
    
    @IBOutlet var customTicketsListingTableView:UITableView?
       var root:CustomTicketsRootView?
       var customTicketsListingArray = [MemoriesInfo]()
       var spinner = UIActivityIndicatorView(style: .gray)
       var controller:CustomTicketsController?

    
    override func viewDidLayout() {
           super.viewDidLayout()
           
           self.customTicketsListingTableView?.separatorStyle = .none
           self.customTicketsListingTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
       }
    
    func initailizeAdapter(info:[MemoriesInfo]?){
           
           guard let info = info else {
               return
           }
        customTicketsListingArray = info
        customTicketsListingTableView?.dataSource = self
        customTicketsListingTableView?.delegate = self
        customTicketsListingTableView?.reloadData()
       }
    
    
    func hidePaginationLoader(){
        
        spinner.stopAnimating()
        self.customTicketsListingTableView?.tableFooterView?.isHidden = true
    }
    
    func insertPageData(info:MemoriesInfo?){
        
        guard let info = info else {
            return
        }
        self.customTicketsListingArray.append(info)
        self.customTicketsListingTableView?.beginUpdates()
        self.customTicketsListingTableView?.insertRows(at: [IndexPath(row: self.customTicketsListingArray.count-1, section: 0)],with:  UITableView.RowAnimation.automatic)
        self.customTicketsListingTableView?.endUpdates()
    }
    
}

extension CustomTicketsAdapter : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return customTicketsListingArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
