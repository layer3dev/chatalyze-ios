
//
//  InAppPurchaseProductFetch.swift
//  Chatalyze
//
//  Created by Sumant Handa on 16/02/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseProductFetch : NSObject{
    
    private var productsRequest: SKProductsRequest?
    private var completionListener : ((_ success: Bool, _ products: [SKProduct]?) -> ())?
    
    
    func requestProducts(identifiers : [String], completionListener: @escaping (_ success: Bool, _ products: [SKProduct]?) -> ()) {
        self.completionListener = completionListener
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set(identifiers))
        self.productsRequest = productsRequest
        
        productsRequest.delegate = self
        productsRequest.start()
    }
    
}

// MARK: - SKProductsRequestDelegate

extension InAppPurchaseProductFetch: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        updateListener(success: true, products: products)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        updateListener(success: false, products: nil)
    }
    
    private func updateListener(success: Bool, products: [SKProduct]?){
        completionListener?(success, products)
        completionListener = nil
    }
    
    
}
