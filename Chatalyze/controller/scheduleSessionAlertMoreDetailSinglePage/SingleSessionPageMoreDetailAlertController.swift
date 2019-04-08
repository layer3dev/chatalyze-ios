//
//  SingleSessionPageMoreDetailAlertController.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SingleSessionPageMoreDetailAlertController: UIViewController {
    
    var controller:EditSessionFormController?
    
    @IBOutlet var threeEdgesView:UIView?
    @IBOutlet var titleScroll:UIScrollView?
    @IBOutlet var dateScroll:UIScrollView?
    @IBOutlet var timeScroll:UIScrollView?
    @IBOutlet var sessionLengthScroll:UIScrollView?
    @IBOutlet var singleChatScroll:UIScrollView?
    @IBOutlet var chatPriceScroll:UIScrollView?
    @IBOutlet var donationScroll:UIScrollView?
    @IBOutlet var screenShotScroll:UIScrollView?
    
    enum infoType:Int{
    
        case title = 0
        case date = 1
        case time = 2
        case sessionLength = 3
        case singleChatLength = 4
        case chatPrice = 5
        case donation = 6
        case screenShot = 7
        case none = 8
    }
    
    var currentInfo = infoType.none
    
    //Session length Label for send us and what is next Session
    @IBOutlet var sessionLengthBottomTextView:UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintInterface()
        paintUI()
    }
    
    func paintUI(){
        //self.sessionLengthBottomLabel?.text =
        
        DispatchQueue.main.async {
       
           
            
            let textOne = "For more details, check out our "
            let textOneMutableAttr = textOne.toMutableAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor(hexString: "929292"), isUnderLine: false)
            
            let textTwo = "What is a chat session"
            let textTwoAttr = textTwo.toAttributedStringLink(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor(hexString: "8EC3F2"), isUnderLine: true, url: "www.google.com")
            
            let textThree = " post or feel free to "
            let textThreeAttr = textThree.toAttributedString(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor(hexString: "929292"), isUnderLine: false)
            
            let textFour = "contact us!"
            let textFourAttr = textFour.toAttributedStringLink(font: "Nunito-Regular", size: UIDevice.current.userInterfaceIdiom == .pad ? 20:16, color: UIColor(hexString: "8EC3F2"), isUnderLine: true, url: "www.google.com")
            
            textOneMutableAttr.append(textTwoAttr)
            textOneMutableAttr.append(textThreeAttr)
            textOneMutableAttr.append(textFourAttr)
            
            self.sessionLengthBottomTextView?.attributedText = textOneMutableAttr
            
             self.initializeLink()
        }
        
        //For more details, check out our What is a chat session post or feel free to contact us!
    }
    
    
    
    func paintInterface(){
        
        if currentInfo == .none {
            return
        }
        if currentInfo == .title {
            hideAll()
            self.titleScroll?.isHidden = false
            return
        }
        if currentInfo == .date {
            hideAll()
            self.dateScroll?.isHidden = false
            return
        }
        if currentInfo == .time {
            hideAll()
            self.timeScroll?.isHidden = false
            return
        }
        if currentInfo == .sessionLength {
            hideAll()
            self.sessionLengthScroll?.isHidden = false
            return
        }
        if currentInfo == .singleChatLength {
            hideAll()
            self.singleChatScroll?.isHidden = false
            return
        }
        if currentInfo == .chatPrice {
            hideAll()
            self.chatPriceScroll?.isHidden = false
            return
        }
        if currentInfo == .donation {
            hideAll()
            self.donationScroll?.isHidden = false
            return
        }
        if currentInfo == .screenShot {
            hideAll()
            self.screenShotScroll?.isHidden = false
            return
        }
    }
    
    @IBAction func dismissAction(sender:UIButton?){
        
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func showContactUsScreen(sender:UIButton?){
        
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                guard let controller = ContactUsController.instance() else{
                    return
                }
                self.controller?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
    func hideAll(){
        
        self.titleScroll?.isHidden = true
        self.dateScroll?.isHidden = true
        self.timeScroll?.isHidden = true
        self.sessionLengthScroll?.isHidden = true
        self.singleChatScroll?.isHidden = true
        self.chatPriceScroll?.isHidden = true
        self.donationScroll?.isHidden = true
        self.screenShotScroll?.isHidden = true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.threeEdgesView?.roundCorners(corners: [.bottomRight,.topLeft,.topRight], radius: 25)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    class func instance()->SingleSessionPageMoreDetailAlertController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSessionSinglePage", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleSessionPageMoreDetailAlert") as? SingleSessionPageMoreDetailAlertController
        return controller
    }
}

extension SingleSessionPageMoreDetailAlertController:UITextViewDelegate {
    
    func initializeLink(){
        
        self.sessionLengthBottomTextView?.delegate = self
        self.sessionLengthBottomTextView?.isSelectable = true
        self.sessionLengthBottomTextView?.isEditable = false
        self.sessionLengthBottomTextView?.dataDetectorTypes = .link
        self.sessionLengthBottomTextView?.isUserInteractionEnabled = true
        self.sessionLengthBottomTextView?.linkTextAttributes = [NSAttributedString.Key.font:UIColor(hexString:AppThemeConfig.themeColor)]
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range == textView.text?.range(of: "What is a chat session")?.nsRange {
            Log.echo(key: "yud", text: "contact us is called")
        }
        
        if  range == textView.text?.range(of: "contact us!")?.nsRange {
            Log.echo(key: "yud", text: "FAQ is called")
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        Log.echo(key: "yud", text: "interacting with url")
        
        if characterRange == self.sessionLengthBottomTextView?.text?.range(of: "What is a chat session")?.nsRange {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true) {                    
                    Log.echo(key: "yud", text: "What is a chat session executed")
                    guard let controller = FAQWebController.instance() else{
                        return
                    }
                    controller.nameofTitle = "What is a chat session"
                    controller.url = "https://support.chatalyze.com/hc/en-us/articles/360019256433-What-is-a-chat-session"
                    self.controller?.navigationController?.pushViewController(controller, animated: true)
                    return
                }
            }
        }
        
        if characterRange == self.sessionLengthBottomTextView?.text?.range(of: "contact us!")?.nsRange {
            
            Log.echo(key: "yud", text: "contact us! executed")
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    guard let controller = ContactUsController.instance() else{
                        return
                    }
                    self.controller?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            return false
        }
        return false
    }
}
