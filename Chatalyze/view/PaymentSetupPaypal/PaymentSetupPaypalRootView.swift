//
//  PaymentSetupPaypalRootView.swift
//  Chatalyze
//
//  Created by Mansa on 27/07/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class PaymentSetupPaypalRootView:ExtendedView{

    var controller:PaymentSetupPaypalController?
    @IBOutlet var pendingAmountLbl:UILabel?
    
    @IBOutlet var ticketSalesAmount:UILabel?
    @IBOutlet var tipAmount:UILabel?
    let amount = "$"
    
    @IBOutlet var paymentTableView:UITableView?
    @IBOutlet var paymentAdapter:AnalystPaymentHistoryAdapter?
    
    @IBOutlet var payoutDetailLabel:UILabel?
    @IBOutlet var payoutDetailView:UIView?
    
    @IBOutlet var paymentHistory:UILabel?
    @IBOutlet var paymentHistoryView:UIView?

    override func viewDidLayout() {
        super.viewDidLayout()        
    }
    
    @IBAction func payoutDetailAction(sender:UIButton?){
        
        resetPaymentsTextUI()
        
        self.payoutDetailLabel?.textColor = UIColor(hexString: "#FAA579")
        self.payoutDetailView?.backgroundColor = UIColor(hexString: "#FAA579")
        
        self.paymentHistory?.textColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
        self.paymentHistoryView?.backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: 0.35) {
            
            self.paymentAdapter?.alpha = 0
            self.layoutIfNeeded()
        }
    }
    
    func resetPaymentsTextUI(){
        
        self.payoutDetailLabel?.textColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
        self.payoutDetailView?.backgroundColor = UIColor.clear
        
        self.paymentHistory?.textColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
        self.paymentHistoryView?.backgroundColor = UIColor.clear
    }
    
    @IBAction func paymentHistoryAction(sender:UIButton?){
        
        resetPaymentsTextUI()
        
        self.paymentHistory?.textColor = UIColor(hexString: "#FAA579")
        self.paymentHistoryView?.backgroundColor = UIColor(hexString: "#FAA579")
        
        UIView.animate(withDuration: 0.35) {
            
            self.paymentAdapter?.alpha = 1
            self.layoutIfNeeded()
        }

    }
    
    func initializeAdapter(){
        
        paymentAdapter?.customDelegate = self
        paymentAdapter?.reloadData()
    }
    func updateInfo(info:[AnalystPaymentInfo]){
        paymentAdapter?.updateInfo(info: info)
    }
    
    
    func fillBiilingInfo(info:BillingInfo?){
        
        pendingAmountLbl?.text = (self.amount)+(info?.pendingAmount ?? "")
        ticketSalesAmount?.text = (self.amount)+(info?.earnedAmount ?? "")
        tipAmount?.text = (self.amount)+(info?.tipAmount ?? "")
    }
}

extension PaymentSetupPaypalRootView:AnalysPaymentHistoryAdapterInterface{
    
    func getPaymentTableView() -> UITableView {
        return paymentTableView!
    }
    
    func fetchingStatus()->Bool{
        return controller?.isFetching ?? false
    }
    
    func fetchedStatus()->Bool{
        return controller?.isFetechingCompleted ?? false
    }
    
    func fetchData(){
        controller?.fetchPaymentHostoryForPagination()
    }
    
}
