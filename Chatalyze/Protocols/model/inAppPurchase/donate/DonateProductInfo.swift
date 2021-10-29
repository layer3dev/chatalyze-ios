//
//  DonateProductInfo.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import StoreKit

class DonateProductInfo{
    
    enum value {
        case two
        case six
        case ten
        
        func getValue() -> Double {
            switch self {
            case .two:
                return 1.99
            case .six:
                return 5.99
            case .ten:
                return 9.99
            default:
                return 0.00
            }
        }
        
        func getProductId() -> String {
            switch self {
            case .two:
                return DonateProductConfig.dollarTwoDonationIdentifier
            case .six:
                return DonateProductConfig.dollarSixDonationIdentifier
            case .ten:
                return DonateProductConfig.dollarTenDonationIdentifier
            default:
                return ""
            }
        }
    }
    
    
    static let identifiers = [DonateProductConfig.dollarTwoDonationIdentifier, DonateProductConfig.dollarSixDonationIdentifier, DonateProductConfig.dollarTenDonationIdentifier]
    
    var productInfo : SKProduct
    
    init(info : SKProduct){
        self.productInfo = info
    }
    
    var productValue : value?{
        switch productInfo.productIdentifier{
        case DonateProductConfig.dollarTwoDonationIdentifier:
            return .two
        case DonateProductConfig.dollarSixDonationIdentifier:
            return .six
        case DonateProductConfig.dollarTenDonationIdentifier:
            return .ten
        default:
            return nil
        }
    }
    
}
