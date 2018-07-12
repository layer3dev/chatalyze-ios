//
//  ReviewController.swift
//  Chatalyze
//
//  Created by Mansa on 24/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class ReviewController: InterfaceExtendedController{
    
    @IBOutlet var text:UITextView?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    @IBOutlet var hieghtofTextView:NSLayoutConstraint?
    @IBOutlet var rootView:ReviewRootView?
    @IBOutlet var reasonLable:UILabel?
    var eventInfo : EventScheduleInfo?
    var dismissListner:(()->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        paintInterface()
    }
    
    func initializeVariable(){
        
        scrollView?.bottomContentOffset = scrollContentBottomOffset
        text?.delegate = self
        hieghtofTextView?.constant = text?.contentSize.height ?? 36.0
        rootView?.controller = self
        rootView?.eventInfo = self.eventInfo
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "Review")
        paintBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButton(sender:UIButton){
        
        //{"comments":"hello","rating":4,"callscheduleId":2271,"analystId":36,"userId":50}
        
        guard let comment = text?.text else {
            return
        }
        guard let rating = rootView?.ratingView?.value else{
            return
        }
        guard let callScheduleId = eventInfo?.id else{
            return
        }
        guard let analystId = eventInfo?.user?.id else{
            return
        }
        guard let userId = SignedUserInfo.sharedInstance?.id else{
            return
        }
        
        //self.startAnimating()
        self.showLoader()
        //SubmitCallReviewProcessor().submit(comments: "hello", rating: CGFloat(4.0) , callscheduleId: 2271, analystId: "36", userId: "50") { (success, message, response) in
        
        SubmitCallReviewProcessor().submit(comments: comment, rating:rating , callscheduleId: callScheduleId, analystId: analystId, userId: userId) { (success, message, response) in
            
            //            Log.echo(key: "yud", text: "The value of the response is \(response)")
            
            self.stopLoader()
            self.dismiss()
        }
    }
    
    @IBAction func dismiss(){
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                if let listner = self.dismissListner{
                    listner()
                }
            }
        }
    }
}

extension ReviewController{
    
    class func instance()->ReviewController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Review") as? ReviewController
        return controller
    }
}

extension ReviewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        reasonLable?.text = ""
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        reasonLable?.text = ""
        scrollView?.activeField = textView
        hieghtofTextView?.constant = textView.contentSize.height
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        hieghtofTextView?.constant = textView.contentSize.height
    }
}
