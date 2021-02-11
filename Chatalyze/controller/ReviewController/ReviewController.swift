//
//  ReviewController.swift
//  Chatalyze
//
//  Created by Mansa on 24/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import ChatSDK
import MessagingSDK

class ReviewController: InterfaceExtendedController{
   
    @IBOutlet var text:UITextView?
    @IBOutlet var scrollView:FieldManagingScrollView?
    @IBOutlet fileprivate var scrollContentBottomOffset : NSLayoutConstraint?
    @IBOutlet var hieghtofTextView:NSLayoutConstraint?
    @IBOutlet var rootView:ReviewRootView?
    @IBOutlet var reasonLable:UILabel?
    var eventInfo : EventScheduleInfo?
    var dismissListner:(()->())?
    let TAG = "ReviewController"
    
    override func viewDidLayout(){
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
        
        paintBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.paintNavigationTitle(text: "Review")
        self.hideNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.showNavigationBar()
    }
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated.
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
        
        self.showLoader()
        
        SubmitCallReviewProcessor().submit(comments: comment, rating:rating , callscheduleId: callScheduleId, analystId: analystId, userId: userId) { (success, message, response) in
            
            //Log.echo(key: "yud", text: "The value of the response is \(response)")
            self.stopLoader()
            self.dismiss()
        }
    }
    
    @IBAction func showChatController(){
        Log.echo(key: self.TAG, text: "chatControllerShown called")
        do {
            let chatEngine = try ChatEngine.engine()
    
            let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [])
            self.presentModally(viewController)
//            self.navigationController?.present(viewController, animated: true, completion: nil)
        } catch {
            // handle error
        }
    }
    
    
    @IBAction func dismiss(){
        
        DispatchQueue.main.async {
            self.getRootPresentingController()?.dismiss(animated: true, completion: {
                if let listner = self.dismissListner{
                    listner()
                }
            })
        }
        
        self.navigationController?.popToRootViewController(animated: true)
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            
            reasonLable?.text = "Any comments?"
        }
    }
    private func presentModally(_ viewController: UIViewController,
                                presenationStyle: UIModalPresentationStyle = .overFullScreen) {
        
        let leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissViewController))
        leftBarButtonItem.tintColor = .white
        
         viewController.navigationItem.leftBarButtonItem = leftBarButtonItem

              let navigationController = UINavigationController(rootViewController: viewController)
              navigationController.modalPresentationStyle = presenationStyle
              present(navigationController, animated: true)
          }
    @objc private func dismissViewController() {
      dismiss(animated: true, completion: nil)
    }
}
