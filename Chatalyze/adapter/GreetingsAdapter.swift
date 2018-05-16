//
//  GreetingsAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class GreetingsAdapter: NSObject {
    var root:GreetingRootView?
    var greetingArray = [GreetingInfo]()
}

extension GreetingsAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return greetingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GreetingCell", for: indexPath) as? GreetingCell else {
            
            return UITableViewCell()
        }
        if indexPath.row < self.greetingArray.count{
            
            cell.fillInfo(info:self.greetingArray[indexPath.row])
            return cell
        }
        
        //        if indexPath.row == self.greetingArray.count - 1 {
        //            root?.fetchDataForPagination()
        //        }
        return UITableViewCell()
    }
}

extension GreetingsAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 361.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let controller = GreetingInfoController.instance() else {
            return
        }
        if indexPath.row < self.greetingArray.count {
            
            controller.info = self.greetingArray[indexPath.row]
        }
        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}


