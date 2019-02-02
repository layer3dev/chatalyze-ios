//
//  SessionDetailCellAdapter.swift
//  Chatalyze
//
//  Created by mansa infotech on 28/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

protocol SessionDetailCellAdapterProtocols {
    
    func updateUI(height:CGFloat)
    func tableViewRefrence()->UITableView?
}

class SessionDetailCellAdapter: ExtendedView {
    
    var delegate:SessionDetailCellAdapterProtocols?
    var emptySlotInfo = [EmptySlotInfo]()
    var tableView:UITableView?
    
    func initilaize(tableView:UITableView?){
        
        DispatchQueue.main.async {
          
            self.tableView = tableView
            self.tableView?.separatorStyle = .none
            self.tableView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        }        
    }
    
    func initializeAdapter(emptySlotInfo:[EmptySlotInfo]?){
        
        DispatchQueue.main.async {
            
            guard let array = emptySlotInfo else{
                return
            }
            self.emptySlotInfo = array
            self.tableView?.dataSource = self
            self.tableView?.delegate = self
            self.tableView?.reloadData()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        DispatchQueue.main.async {
            
            self.tableView?.layer.removeAllAnimations()
            self.delegate?.updateUI(height: self.tableView?.contentSize.height ?? 0.0)
        }
    }
}


extension SessionDetailCellAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        Log.echo(key: "YUD", text: "I AM CALLING")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return memoriesListingArray.count
        return self.emptySlotInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SessionDetailTable", for: indexPath) as? SessionDetailTableCell else {
            return UITableViewCell()
        }
        
        if indexPath.row < self.emptySlotInfo.count {
        
            cell.fillInfo(info: self.emptySlotInfo[indexPath.row],index:indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

extension SessionDetailCellAdapter:UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}

