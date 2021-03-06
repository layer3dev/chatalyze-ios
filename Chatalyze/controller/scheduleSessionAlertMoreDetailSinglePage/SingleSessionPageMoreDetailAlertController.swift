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
    @IBOutlet var autographScroll:UIScrollView?
    @IBOutlet var breakScrollView:UIScrollView?
    @IBOutlet var sponsorScroll:UIScrollView?
    @IBOutlet var bookingStyleScroll:UIScrollView?
    
    
    enum infoType:Int{
        
        case title = 0
        case date = 1
        case time = 2
        case sessionLength = 3
        case singleChatLength = 4
        case chatPrice = 5
        case donation = 6
        case screenShot = 7
        case breakScroll = 8
        case sponsor = 9
        case bookingStyle = 10
        case autograph = 11
        case none = 12
    }
    
    var currentInfo = infoType.none
    
    //Session length Label for send us and what is next Session
    @IBOutlet var sessionLengthBottomTextView:UITextView?
    @IBOutlet var priceLabel:UILabel?
    
    @IBOutlet var standardInfoLabel:UILabel?
    @IBOutlet var flexInfoLabel:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintInterface()
    }
    
   
    
    func paintUI(){
        
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
            
            let sizeOFFont  = UIDevice.current.userInterfaceIdiom == .pad ? 20:16
            
            let textOneNew = "You can set a ticket price or offer them for free – it's totally your call! If you set a price, you will receive your earnings (net of service and processing fees) 48 hours after the session. "
            
            let textOneMutable = textOneNew.toMutableAttributedString(font: "Nunito-Regular", size: sizeOFFont, color: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), isUnderLine: false)
            
            let textTwoNew = "Please note that the no-show rate is much higher for free chats than it is for paid chats."
            
            let textTwoAttrNew = textTwoNew.toAttributedString(font: "Nunito-ExtraBold", size: sizeOFFont, color: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), isUnderLine: false)
            
            textOneMutable.append(textTwoAttrNew)
            
            self.priceLabel?.attributedText = textOneMutable
            
        }
    }
    
    
    func paintBookingStyleNew(){
        
        DispatchQueue.main.async {
            
            let size = UIDevice.current.userInterfaceIdiom == .pad ? 20:16
            
            let bookingOneText = "Standard: "
            
            let bookingTwoText = "If you select Standard, your chats will automatically be sequenced one after another so you avoid the risk of having long empty gaps between chats. People who want to book a chat will only see the next available time slot and will not have the option to select one of the later chats in the session instead."
            
            let bookTextOneMutable = bookingOneText.toMutableAttributedString(font: "Nunito-Bold", size: size, color: UIColor(hexString: "#929292"), isUnderLine: false)
            
            let bookingTextTwoAttr = bookingTwoText.toMutableAttributedString(font: "Nunito-Regular", size: size, color: UIColor(hexString: "#929292"), isUnderLine: false)
            
            bookTextOneMutable.append(bookingTextTwoAttr)
            
            let bookingThreeText = "Flex: "
            
            let bookingFourText = "If you select Flex, people will be able to select which chat they want to book from all of the available times. If the session does not get fully booked, you may have gaps between some of your chats."
            
            let bookTextThreeMutable = bookingThreeText.toMutableAttributedString(font: "Nunito-Bold", size: size, color: UIColor(hexString: "#929292"), isUnderLine: false)
            
            let bookingTextFourAttr = bookingFourText.toMutableAttributedString(font: "Nunito-Regular", size: size, color: UIColor(hexString: "#929292"), isUnderLine: false)
            
            bookTextThreeMutable.append(bookingTextFourAttr)
            
            self.standardInfoLabel?.attributedText = bookTextOneMutable
            self.flexInfoLabel?.attributedText = bookTextThreeMutable
            
        }
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
      
      if currentInfo == .autograph {
             hideAll()
             self.autographScroll?.isHidden = false
             return
           }
      
        if currentInfo == .breakScroll {
            hideAll()
            self.breakScrollView?.isHidden = false
            return
        }
        if currentInfo == .sponsor {
            hideAll()
            self.sponsorScroll?.isHidden = false
            return
        }
        if currentInfo == .bookingStyle{
            hideAll()
            self.bookingStyleScroll?.isHidden = false
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
        self.breakScrollView?.isHidden = true
        self.sponsorScroll?.isHidden = true
        self.bookingStyleScroll?.isHidden = true
        self.autographScroll?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.threeEdgesView?.roundCorners(corners: [.bottomRight,.topLeft,.topRight], radius: 25)
        
        self.paintBookingStyleNew()
        self.paintUI()

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
