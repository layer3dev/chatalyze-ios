//
//  PaymentListingController.swift
//  Chatalyze
//
//  Created by Mansa on 17/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PaymentListingController: InterfaceExtendedController {

    @IBOutlet var rootView:PaymentListRootView?
    var paymentListingArray = [PaymentListingInfo]()
    @IBOutlet var nogreetLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
       
        paintInterface()
        initializeVariable()
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "PAYMENT HISTORY")
        paintBackButton()
    }
    
    func initializeVariable(){
        
        self.rootView?.controller = self
        getPaymentInfo()
    }
    
    func getPaymentInfo(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        self.showLoader()
        
        PaymentHistoryProcessor().fetchInfo(id: id, offset: 0) { (success, info) in
                        
            self.stopLoader()
            self.paymentListingArray.removeAll()
            self.nogreetLbl?.isHidden = true
            if success{
                
                if let array  = info{
                    if array.count > 0{
                        for info in array{
                            self.paymentListingArray.append(info)
                        }
                        self.rootView?.fillInfo(info: self.paymentListingArray)
                        self.nogreetLbl?.isHidden = true
                        return
                    }else if array.count <= 0{
                        self.nogreetLbl?.isHidden = false
                        self.rootView?.fillInfo(info: self.paymentListingArray)
                    }
                    return
                }
            }
            self.nogreetLbl?.isHidden = false
            self.rootView?.fillInfo(info: self.paymentListingArray)
            return
        }
    }    
    
    func fetchDataForPagination(){
        
        guard let selfId = SignedUserInfo.sharedInstance?.id
            else{
                return
        }
        
        PaymentHistoryProcessor().fetchInfo(id: selfId, offset: self.paymentListingArray.count) { (success, info) in
            
            if success{
                if let array = info{
                    if array.count > 0{
                        
                        var arrayForDuplicateChecking = self.paymentListingArray
                        for i in 0..<array.count{
                            var loopController = 1
                            var isEqual = false
                            for index in stride(from: arrayForDuplicateChecking.count-1, to: -1, by: -1) {
                                if array[i].id == arrayForDuplicateChecking[index].id{
                                    isEqual = true
                                    break
                                }
                                if loopController == 10{
                                    break
                                }
                                loopController = loopController + 1
                            }
                            if isEqual == false{
                                
                                //send Data to insert in the UItableView
                                self.rootView?.insertPageData(info: array[i])
                                self.paymentListingArray.append(array[i])
                            }
                        }
                        return
                    }
                    self.rootView?.hidePaginationLoader()
                    return
                }
            }
            self.rootView?.hidePaginationLoader()
            return
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension PaymentListingController{
    
    class func instance()->PaymentListingController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentListing") as? PaymentListingController
        return controller
    }
}
