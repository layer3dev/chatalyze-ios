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
import SendBirdSDK
import SendBirdUIKit

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
        initiateSendbird()
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
        createSendbirdChatChannel()
//        Log.echo(key: self.TAG, text: "chatControllerShown called")
//        do {
//            let chatEngine = try ChatEngine.engine()
//
//            let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [])
//            self.presentModally(viewController)
////            self.navigationController?.present(viewController, animated: true, completion: nil)
//        } catch {
//            // handle error
//        }
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
        
        let leftBarButtonItem = UIBarButtonItem(title: "Close".localized() ?? "", style: .done, target: self, action: #selector(dismissViewController))
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

extension ReviewController {
    func createUserId(room_id: String, id: String) -> String {
        return AppConnectionConfig.webServiceURL.contains("dev") ? "dev_\(room_id)_\(id)" : "live_\(room_id)_\(id)"
    }

    func initiateChannel(groupURL: SBDGroupChannel) {
        groupURL.join(completionHandler: { (error) in
            guard error == nil else {
                return
            }
            let channelVC = SBUChannelViewController(channelUrl: groupURL.channelUrl)
            channelVC.messageInputView.addButton?.removeFromSuperview()
            channelVC.useRightBarButtonItem = false
            channelVC.channelName = "Live Support"
            channelVC.loadChannel(channelUrl: groupURL.channelUrl)
        })
    }
    
    func goToChannel(groupURL: SBDGroupChannel) {
        guard let user = SignedUserInfo.sharedInstance else {
            return
        }
        SBDMain.updateCurrentUserInfo(withNickname: user.firstName, profileUrl: user.profileImage) { error in
            guard error == nil else {
                return
            }
            groupURL.join(completionHandler: { (error) in
                guard error == nil else {
                    self.stopLoader()
                    return
                }
                let channelVC = SBUChannelViewController(channelUrl: groupURL.channelUrl)
                channelVC.messageInputView.addButton?.removeFromSuperview()
                channelVC.useRightBarButtonItem = false
                channelVC.channelName = "Live Support"
                let naviVC = UINavigationController(rootViewController: channelVC)
                self.present(naviVC, animated: true)
            })
        }
    }

    func initiateSendbird() {
        guard let users = SignedUserInfo.sharedInstance else {
            return
        }
        let userId = self.createUserId(room_id: self.eventInfo?.room_id ?? "", id: users.id ?? "")
        SBDMain.connect(withUserId: userId) { user, err in
            guard err == nil else {
                return
            }
            SBUGlobals.CurrentUser = SBUUser(userId: userId, nickname:users.firstName ?? "", profileUrl:users.profileImage ?? "")
            SBDMain.add(self as SBDChannelDelegate, identifier: userId)
        }
    }
    
    func createSendbirdChatChannel() {
        guard let user = SignedUserInfo.sharedInstance else {
            return
        }
        let userId = createUserId(room_id: eventInfo?.room_id ?? "", id: user.id ?? "")
        let host = createUserId(room_id: eventInfo?.room_id ?? "", id: self.eventInfo?.user?.id ?? "")
        let admin = createUserId(room_id: eventInfo?.room_id ?? "", id: "\(self.eventInfo?.user?.organization?.adminId ?? 0)")
        let channelUrl = "chatalyze_\(self.eventInfo?.room_id ?? "")_\(self.eventInfo?.user?.id ?? "")_\(user.id ?? "")"
        let channelName = "\(self.eventInfo?.room_id ?? "")_\(self.eventInfo?.user?.id ?? "")_\(user.id ?? "")"
        SBUGlobals.CurrentUser = SBUUser(userId: userId, nickname:user.firstName ?? "", profileUrl:user.profileImage ?? "")
        SBDMain.add(self as SBDChannelDelegate, identifier: userId)
        SBDMain.connect(withUserId: userId) { user, err in
            guard err == nil else {
                self.stopLoader()
                return
            }
            SBDGroupChannel.getWithUrl(channelUrl) { groupChannel, error in
                if error == nil {
                    self.goToChannel(groupURL: groupChannel!)
                } else {
                    var users: [String] = []
                    users.append(admin)
                    users.append(host)
                    users.append(userId)
                    let params = SBDGroupChannelParams()
                    params.isPublic = true
                    params.isDistinct = false
                    params.addUserIds(users)
                    params.operatorUserIds = [userId]
                    params.name = channelName
                    params.channelUrl = channelUrl
                    SBDGroupChannel.createChannel(with: params, completionHandler: { (groupChannel, error) in
                        guard error == nil else {
                            self.stopLoader()
                            return
                        }
                        self.goToChannel(groupURL: groupChannel!)
                    })
                }
            }
        }
    }
}

extension ReviewController: SBDChannelDelegate, SBDConnectionDelegate {
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if let room = self.eventInfo?.room_id {
            if message.channelUrl.contains(room) {
                SBDGroupChannel.getWithUrl(message.channelUrl) { groupChannel, error in
                    guard error == nil else {
                        return
                    }
                    self.goToChannel(groupURL: groupChannel!)
                }
            }
        }
    }
}
