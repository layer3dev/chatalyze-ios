
//
//  MemoriesAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 19/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MemoriesAdapter: ExtendedView {
    
    @IBOutlet var memoriesListingTableView:UITableView?
    var root:MemoriesRootView?
    var memoriesListingArray = [MemoriesInfo]()
    var spinner = UIActivityIndicatorView(style: .gray)
    var controller:MemoriesController?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.memoriesListingTableView?.separatorStyle = .none
        self.memoriesListingTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
    }
    
    func initailizeAdapter(info:[MemoriesInfo]?){
        
        guard let info = info else {
            return
        }
        memoriesListingArray = info
        memoriesListingTableView?.dataSource = self
        memoriesListingTableView?.delegate = self
        memoriesListingTableView?.reloadData()
    }
}

extension MemoriesAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memoriesListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoriesCell", for: indexPath) as? MemoriesCell else {
            
            return UITableViewCell()
        }
        if indexPath.row < self.memoriesListingArray.count{
            
            cell.fillInfo(info:self.memoriesListingArray[indexPath.row])
            cell.controller = self.controller
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let numberOfRow = tableView.numberOfRows(inSection: 0)
        //&& dataLimitReached == false
        if indexPath.row  == numberOfRow - 1 {
            
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            self.memoriesListingTableView?.tableFooterView = spinner
            self.memoriesListingTableView?.tableFooterView?.isHidden = false
            root?.fetchDataForPagination()
        }else{
            
            //we should never hide paginated loader from here as It is good to hide from data Coming Service method.Its not it's work.
            //self.eventInfoTableView?.tableFooterView?.isHidden = true
        }
    }
    
    
    func insertPageData(info:MemoriesInfo?){
        
        guard let info = info else {
            return
        }
        self.memoriesListingArray.append(info)
        self.memoriesListingTableView?.beginUpdates()
        self.memoriesListingTableView?.insertRows(at: [IndexPath(row: self.memoriesListingArray.count-1, section: 0)],with:  UITableView.RowAnimation.automatic)
        self.memoriesListingTableView?.endUpdates()
    }
    
    func hidePaginationLoader(){
        
        spinner.stopAnimating()
        self.memoriesListingTableView?.tableFooterView?.isHidden = true
    }
}

extension MemoriesAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 352.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        guard let controller = GreetingInfoController.instance() else {
    //            return
    //        }
    //        if indexPath.row < self.PaymentListingArray.count {
    //
    //            controller.info = self.PaymentListingArray[indexPath.row]
    //        }
    //        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    //    }
}

extension MemoriesAdapter:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        Log.echo(key: "yud", text: "Table scroll contentoffset is \(String(describing: self.memoriesListingTableView?.contentOffset.y))")
        self.root?.updateTableContentOffset(offset:self.memoriesListingTableView?.contentOffset.y)
    }
}

