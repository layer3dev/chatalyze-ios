//
//  SessionTicketCell.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 14/06/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class SessionTicketCell : ExtendedTableCell {

    var isJoinDisabel = false
    var ticketFrameStr : String?
    var profileImageStr : String?
    var rootAdapter:MyTicketesVerticalAdapter?
    @IBOutlet var headerImage:UIImageView?
    @IBOutlet var borderView:UIView?
    @IBOutlet var chatnumberLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var startDateLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet weak var btnChat: UIButton!
    
    var delegate:MyTicketCellDelegate?
    var info:EventSlotInfo?
    let controller =  CameraTestController()
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    
    @IBOutlet var joinButtonContainer:UIView?
    @IBOutlet var stripContainerView : UIView?
    @IBOutlet var joinButtonLayerView:UIView?
    
    @IBOutlet weak var buttonInsideLayer: UIView!
    @IBOutlet var mainView:UIView?
    
    @IBOutlet var profileImage:UIImageView?
    @IBOutlet var hostName:UILabel?
    
    @IBOutlet var sponsorView:UIImageView?
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        self.selectionStyle = .none
        
    }
    
    func paintInterface() {
        
        self.mainView?.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 8.0, opacity: 0.35)
    }
    
    func paintGradientColorOnJoinSessionButton() {
        
        let reqLayer = CAGradientLayer()
        reqLayer.colors = [UIColor(red: 65.0/255.0, green: 166.0/255.0, blue: 248.0/255.0, alpha: 1).cgColor,UIColor(red: 100.0/255.0, green: 183.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor,UIColor(red: 148.0/255.0, green: 205.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor]
        reqLayer.frame = self.joinButtonContainer?.bounds ?? CGRect.zero
        reqLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        reqLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        self.joinButtonLayerView?.layer.addSublayer(reqLayer)
//        self.joinButtonContainer?.layer.cornerRadius = (self.joinButtonContainer?.frame.size.height ?? 0.0)/2
//        self.joinButtonContainer?.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        paintGradientColorOnJoinSessionButton()
        
        self.borderView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 6:4
        self.borderView?.layer.masksToBounds = true
        
        //self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    func fillInfo(info:EventSlotInfo?){
        
        guard let info = info else {
            return
        }
        self.info = info
        
        if isJoinDisabel{
          
            self.joinButtonContainer?.isUserInteractionEnabled = false
        }else{
            self.joinButtonContainer?.isUserInteractionEnabled = true
        }
        
        
        self.chatnumberLbl?.text = String(info.slotNo ?? 0)
        initializeDesiredDatesFormat(info:info)
        self.title?.text = "\(info.eventTitle ?? "")"
        self.hostName?.text = "\(info.callschedule?.user?.firstName ?? "")"
 
        fetchBackgroudImg()
        fetchProfileImage()
        mainView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainView?.layer.cornerRadius = 12
        mainView?.layer.masksToBounds = true
        
        joinButtonContainer?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        joinButtonContainer?.layer.cornerRadius = 12
        joinButtonContainer?.layer.masksToBounds = true
        
        sponsorView?.layer.cornerRadius = 12
        buttonInsideLayer.layer.cornerRadius = 6
        buttonInsideLayer.clipsToBounds = true
        
    }
        
    func fetchProfileImage(){
        self.profileImage?.image = nil
        if let profileImage = info?.callschedule?.user?.profileImage{
            if let url = URL(string:profileImage){
                
                self.profileImage?.sd_setImage(with: url, placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                })
                return
            }else{
                self.profileImage?.image = #imageLiteral(resourceName: "user_placeholder")
            }
//
        }else{
            self.profileImage?.image = #imageLiteral(resourceName: "user_placeholder")
        }
        
    }
    
    func fetchBackgroudImg(){
        self.sponsorView?.image = nil
        if let urlString = info?.callschedule?.ticketFrame{
            if let url = URL(string: urlString){
                self.sponsorView?.sd_setImage(with: url, placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                    self.sponsorView?.image = image
                })
                return
            }else{
                self.sponsorView?.backgroundColor = #colorLiteral(red: 0.8979603648, green: 0.8980895877, blue: 0.8979321122, alpha: 1)
            }
        }else{
            self.sponsorView?.backgroundColor = #colorLiteral(red: 0.8979603648, green: 0.8980895877, blue: 0.8979321122, alpha: 1)
        }
    }
    
    
    func initializeDesiredDatesFormat(info:EventSlotInfo){
        
        _formattedEndTime = info.end
        _formattedStartTime = info.start
        self.timeLbl?.text = self.formattedStartTime
        self.startDateLbl?.text = self.formattedStartDate
    }
    
    var _formattedStartTime:String?{
        
        get{
            return formattedStartTime ?? ""
        }
        set{
            
            let date = newValue
            
            if Locale.current.languageCode == "en"{
                formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EEE, MMM dd, yyyy")
            
                formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss")
            } else if Locale.current.languageCode == "zh" {
                formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "yyyy 年 MM 月 d 日")
                
                formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "下午 h 點 mm 分")
            } else if Locale.current.languageCode == "ko" {
                formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "MM월 d일")
                if let time = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss a") {
                    if time.contains("AM") {
                        formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "오전 h시 mm분")
                    } else {
                        formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "오후 h시 mm분")
                    }
                }
            }else{
                formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "dd/MM/yyyy")
                
                formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
            }
            formattedStartTime = "\(formattedStartTime ?? "")-\(formattedEndTime ?? "") \(TimeZone.current.abbreviation() ?? "")"
        }
    }
    
    var _formattedEndTime:String?{
        
        get{
            
            return formattedEndTime ?? ""
        }
        set{
            
            let date = newValue
            if Locale.current.languageCode == "en"{
                formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss a")
            } else if Locale.current.languageCode == "zh" {
                formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "下午 h 點 mm 分")
            } else if Locale.current.languageCode == "ko" {
                if let time = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm:ss a") {
                    if time.contains("AM") {
                        formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "오전 h시 mm분")
                    } else {
                        formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "오후 h시 mm분")
                    }
                }
            }else{
                formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: Locale.current.languageCode == "th" ? "H.mm" : "H:mm")
            }
           
        }
    }
    
    func showAlert(sender:UIButton){
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update App".localized() ?? "", style: UIAlertAction.Style.default) { (success) in
            
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: "Continue to Session".localized() ?? "", style: UIAlertAction.Style.default) { (success) in
            
            self.delegate?.jointEvent(info:self.info)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized() ?? "", style: UIAlertAction.Style.destructive) { (success) in
        }
        
        alertActionSheet.addAction(uploadAction)
        alertActionSheet.addAction(callRoomAction)
        alertActionSheet.addAction(cancel)
        
        
        if let presenter = alertActionSheet.popoverPresentationController {
            
            alertActionSheet.popoverPresentationController?.sourceView =                 self.rootAdapter?.root?.controller?.view
            alertActionSheet.popoverPresentationController?.sourceRect = joinButtonContainer?.frame ?? self.frame
        }
        
        self.rootAdapter?.root?.controller?.present(alertActionSheet, animated: true) {
        }
    }
    
    @IBAction func jointEvent(send:UIButton?){
        
        if HandlingAppVersion().getAlertMessage() != "" {
            showAlert(sender: send ?? UIButton())
            return
        }
        self.delegate?.jointEvent(info:self.info)
    }
    
    
    @IBAction func systemTest(sender:UIButton?){
        
        delegate?.systemTest()
    }
}

extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
