//
//  AnalystPaymentHistoryAdapter.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class AnalystPaymentHistoryAdapter: ExtendedView {
    
    var customDelegate:AnalysPaymentHistoryAdapterInterface?
    var paymentInfo = [AnalystPaymentInfo]()
    var isFetching = false
    var isFetched = false
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        customDelegate?.getPaymentTableView().dataSource = self
        customDelegate?.getPaymentTableView().delegate = self
        customDelegate?.getPaymentTableView().separatorStyle = .none
    }
    
    func reloadData(){
        customDelegate?.getPaymentTableView().reloadData()
    }
    
    func updateInfo(info:[AnalystPaymentInfo]){
        
        self.paymentInfo = info
        customDelegate?.getPaymentTableView().reloadData()
    }
}

extension AnalystPaymentHistoryAdapter:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if !(customDelegate?.fetchedStatus() ?? false) {
          return  paymentInfo.count+1
        }
        return paymentInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = customDelegate?.getPaymentTableView().dequeueReusableCell(withIdentifier: "AnalystPaymentHistoryCell", for: indexPath) as? AnalystPaymentHistoryCell else {
            return UITableViewCell()
        }
        
        
        if indexPath.row >= paymentInfo.count{
            
            guard let loaderCell = customDelegate?.getPaymentTableView().dequeueReusableCell(withIdentifier: "MySessionLoaderCell", for: indexPath) as? MySessionLoaderCell else {
                return UITableViewCell()
            }
            loaderCell.startAnimating()
            return loaderCell
        }
        
        cell.fillInfo(info: paymentInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row >= paymentInfo.count-1{
            customDelegate?.fetchData()
        }
    }
}

extension AnalystPaymentHistoryAdapter:UITableViewDelegate {
}
