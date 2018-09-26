//
//  EventPaymentController.swift
//  Chatalyze
//
//  Created by Mansa on 29/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
//import Stripe

class EventPaymentController: InterfaceExtendedController {
    
    @IBOutlet var rootView:EventPaymentRootView?
    var info:EventInfo?
    var presentingControllerObj:EventController?
    var dismissListner:((Bool)->())?
    
    @IBOutlet var savedCardsTable:UITableView?
    @IBOutlet var heightOfSavedCardContainer:NSLayoutConstraint?
    var cardInfoArray = [CardInfo]()
    var selectedPreviousCell:SavedCardsCell?
    var selectedArray:[Int] = [Int]()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        rootView?.controller = self
        rootView?.info = self.info
        fetchCardDetails()
        initailizeTableView()
    }
    
    func initailizeTableView(){
       
        self.savedCardsTable?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        savedCardsTable?.dataSource = self
        savedCardsTable?.delegate = self
        savedCardsTable?.separatorStyle = .none
        savedCardsTable?.reloadData()
    }
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//
//        heightOfSavedCardContainer?.constant = savedCardsTable?.contentSize.height ?? 0.0
//        //self.view.layoutIfNeeded()
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        savedCardsTable?.layer.removeAllAnimations()
        heightOfSavedCardContainer?.constant = savedCardsTable?.contentSize.height ?? 0.0
        self.updateViewConstraints()
        self.view.layoutIfNeeded()
    }
   /*
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        tableHeightConstraint.constant = tableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateConstraints()
            self.layoutIfNeeded()
        }
    }
 */
    func fetchCardDetails(){
        
        guard let id = SignedUserInfo.sharedInstance?.id else {
            return
        }
        self.showLoader()
        FetchSavedCardDetails().fetchInfo(id: id) { (success, cardInfo) in
            
            self.stopLoader()
            if success{
                
                if let cardinfo = cardInfo{
                    
                    self.cardInfoArray = cardinfo
                    self.rootView?.cardInfoArray = cardinfo
                    
                    var count = 0
                    var arrayofSelection:[Int] = [Int]()
                    
                    for _ in cardinfo{
                        arrayofSelection.append(0)
                        count = count + 1
                    }
                    self.selectedArray = arrayofSelection
                    self.savedCardsTable?.reloadData()
                    self.rootView?.paintInterfaceForSavedCard()
                    
//                    if count == 1{
//
//                        self.rootView?.numberOfSaveCards = 1
//                        self.rootView?.paintInterfaceForSavedCard()
//                    }
//                    if count >= 2{
//
//                        self.rootView?.numberOfSaveCards = 2
//                        self.rootView?.paintInterfaceForSavedCard()
//                    }
                    
                }
            }
        }
    }

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        Log.echo(key: "yud", text: "Touch is \(String(describing: touch.view))")
        
//        if touch.view == self.rootView?.selectDateMonthBtn{
//            Log.echo(key: "yud", text: "Button is called")
//
//            self.rootView?.dateAction(sender: nil)
//            return false
//        }
        return true
    }
    
    //    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return false
    //    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
}

extension EventPaymentController{
    
    class func instance()->EventPaymentController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EventPayment") as? EventPaymentController
        return controller
    }
}


extension EventPaymentController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cardInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = savedCardsTable?.dequeueReusableCell(withIdentifier: "SavedCardsCell", for: indexPath) as? SavedCardsCell else{
            return UITableViewCell()
        }
        if cardInfoArray.count > indexPath.row && self.selectedArray.count > indexPath.row{
            cell.fillInfo(info:cardInfoArray[indexPath.row],isSelected:self.selectedArray[indexPath.row])
        }
        cell.saveCard?.addTarget(self, action: #selector(saveCardAction(sender:)), for: UIControlEvents.touchUpInside)
        cell.saveCard?.tag = indexPath.row
        return cell
    }
}

extension EventPaymentController:UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedArray.count > indexPath.row{
            
            for i in 0..<selectedArray.count{
                selectedArray[i] = 0
            }
            selectedArray[indexPath.row] = 1
            self.rootView?.currentcardInfo = self.cardInfoArray[indexPath.row]
        }
        savedCardsTable?.reloadData()
    }
    
    @objc func saveCardAction(sender:UIButton){
        
        if selectedArray.count > sender.tag{
            
            for i in 0..<selectedArray.count{
                selectedArray[i] = 0
            }
            selectedArray[sender.tag] = 1
            self.rootView?.currentcardInfo = self.cardInfoArray[sender.tag]
        }
        savedCardsTable?.reloadData()
    }
}
