//
//  GreetingDateTimeAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 07/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingDateTimeAdapter: ExtendedView {
    
    var parentRoot:GreetingDateTimeRootView?
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    var selectedRow = [0,0]
}

extension GreetingDateTimeAdapter :UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GreetingDate", for: indexPath) as? GreetingDateCell else{
                return UITableViewCell()
            }
            return cell
            
        }else if indexPath.row == 1 {
           
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GreetingTime", for: indexPath) as? GreetingTimeCell else{
                return UITableViewCell()
            }
            return cell
        }
        return UITableViewCell()
    }
}

//extension GreetingDateTimeAdapter :UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 0 {
//            
//            if selectedRow[0] == 1{
//                
//                selectedRow[0] = 0
//                selectedRow[1] = 0
//                parentRoot?.updateDimenesion(height:130.0)
//            }else{
//                
//                selectedRow[0] = 1
//                selectedRow[1] = 0
//                parentRoot?.updateDimenesion(height:250.0)
//            }
//        }else if indexPath.row == 1{
//          
//            if selectedRow[1] == 1{
//                
//                selectedRow[0] = 0
//                selectedRow[1] = 0
//                parentRoot?.updateDimenesion(height:130.0)
//
//            }else{
//                
//                selectedRow[0] = 0
//                selectedRow[1] = 1
//                parentRoot?.updateDimenesion(height:250.0)
//            }
//        }
//        tableView.beginUpdates()
//        tableView.endUpdates()        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//                
//        if indexPath.row == 0 {
//            if selectedRow[0] == 0{
//                return 61
//            }
//            return 180
//        }else if indexPath.row == 1{
//            if selectedRow[1] == 0{
//                return 61
//            }
//            return 180
//        }
//        return 61
//    }
//}

