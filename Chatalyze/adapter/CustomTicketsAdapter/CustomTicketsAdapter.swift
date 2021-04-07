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
       var customTicketsListingArray = [CustomTicketsInfo]()
       var spinner = UIActivityIndicatorView(style: .gray)
       var controller:CustomTicketsController?

    
    override func viewDidLayout() {
           super.viewDidLayout()
           
        self.customTicketsListingTableView?.register(UINib(nibName: "CustomTicketCell", bundle: nil), forCellReuseIdentifier: "CustomTicketCell")
           self.customTicketsListingTableView?.separatorStyle = .none
           self.customTicketsListingTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
       }
    
    func initailizeAdapter(info:[CustomTicketsInfo]?){
           
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
    
    func addNewResultsWith(info: [CustomTicketsInfo]?) {
      guard let info = info else {
        return
      }
      self.customTicketsListingArray.append(contentsOf: info)
      self.customTicketsListingTableView?.reloadData()
    }
    
    func hideFooterSpinner() {
      self.customTicketsListingTableView?.tableFooterView = nil
      self.customTicketsListingTableView?.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTicketCell", for: indexPath) as? CustomTicketCell

        if indexPath.row < self.customTicketsListingArray.count{
            
            cell?.fillInfo(info:self.customTicketsListingArray[indexPath.row])
            return cell ?? CustomTicketCell()
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      let lastSectionIndex = tableView.numberOfSections - 1
      let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
      if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && self.controller!.dataLimitReached == false && self.controller!.isfetchingPaginationData == false {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(60))
        self.customTicketsListingTableView?.tableFooterView = spinner
        self.customTicketsListingTableView?.tableFooterView?.isHidden = false
        self.controller!.fetchDataForPagination()
      } else {
        self.customTicketsListingTableView?.tableFooterView?.isHidden = true
        
      }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
extension CustomTicketsAdapter:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        Log.echo(key: "yud", text: "Table scroll contentoffset is \(String(describing: self.customTicketsListingTableView?.contentOffset.y))")
        self.root?.updateTableContentOffset(offset:self.customTicketsListingTableView?.contentOffset.y)
    }
}
