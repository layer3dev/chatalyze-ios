//
//  PaymentAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentAdapter: ExtendedView {
    
    @IBOutlet var paymentListingTableView:UITableView?
    var root:PaymentListRootView?
    var PaymentListingArray = [PaymentListingInfo]()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.paymentListingTableView?.separatorStyle = .none
        self.paymentListingTableView?.tableFooterView?.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
    }
    
    func initailizeAdapter(info:[PaymentListingInfo]?){
       
        guard let info = info else {
            return
        }
        PaymentListingArray = info
        Log.echo(key: "yud", text: "Count of the paymentListing is \(PaymentListingArray)")
        paymentListingTableView?.dataSource = self
        paymentListingTableView?.delegate = self
        paymentListingTableView?.reloadData()
    }    
}
extension PaymentAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PaymentListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableCell", for: indexPath) as? PaymentTableCell else {
            
            return UITableViewCell()
        }
        if indexPath.row < self.PaymentListingArray.count{
            cell.fillInfo(info:self.PaymentListingArray[indexPath.row])
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
            self.paymentListingTableView?.tableFooterView = spinner
            self.paymentListingTableView?.tableFooterView?.isHidden = false
            root?.fetchDataForPagination()            
        }else{
            
            //we should never hide paginated loader from here as It is good to hide from data Coming Service method.Its not it's work.
            
            //self.eventInfoTableView?.tableFooterView?.isHidden = true
        }
    }
    
    func insertPageData(info:PaymentListingInfo?){
        
        guard let info = info else {
            return
        }
        self.PaymentListingArray.append(info)
        self.paymentListingTableView?.beginUpdates()
        self.paymentListingTableView?.insertRows(at: [IndexPath(row: self.PaymentListingArray.count-1, section: 0)],with:  UITableViewRowAnimation.automatic)
        self.paymentListingTableView?.endUpdates()
    }
    
    func hidePaginationLoader(){
        
        spinner.stopAnimating()
        self.paymentListingTableView?.tableFooterView?.isHidden = true
    }
}

extension PaymentAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
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
