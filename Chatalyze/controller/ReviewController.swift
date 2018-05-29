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
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
        paintInterface()
    }
    
    func initializeVariable(){
        
        scrollView?.bottomContentOffset = scrollContentBottomOffset
        text?.delegate = self
        hieghtofTextView?.constant = text?.contentSize.height ?? 36.0
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    
   
        scrollView?.activeField = textView
        hieghtofTextView?.constant = textView.contentSize.height
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){
        
       
        hieghtofTextView?.constant = textView.contentSize.height
    }
}
