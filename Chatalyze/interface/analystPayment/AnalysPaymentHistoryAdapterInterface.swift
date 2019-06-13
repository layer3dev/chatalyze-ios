//
//  AnalysPaymentHistoryAdapterInterface.swift
//  Chatalyze
//
//  Created by mansa infotech on 07/06/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

protocol AnalysPaymentHistoryAdapterInterface {
    
    func getPaymentTableView()->UITableView
    func fetchingStatus()->Bool
    func fetchedStatus()->Bool
    func fetchData()
}
