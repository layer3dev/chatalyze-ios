//
//  MyTicketsVerticalCell.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//


import UIKit
import SDWebImage

class MyTicketsVerticalCell: ExtendedTableCell {
    
    var rootAdapter:MyTicketesVerticalAdapter?
    @IBOutlet var headerImage:UIImageView?
    @IBOutlet var borderView:UIView?
    @IBOutlet var chatnumberLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var startDateLbl:UILabel?
    @IBOutlet var title:UILabel?
    var delegate:MyTicketCellDelegate?
    var info:EventSlotInfo?
    
    var formattedStartTime:String?
    var formattedEndTime:String?
    var formattedStartDate:String?
    var fromattedEndDate:String?
    
    @IBOutlet var joinButtonContainer:UIView?
    @IBOutlet var joinButtonLayerView:UIView?
    @IBOutlet var mainView:UIView?
    
    @IBOutlet var profileImage:UIImageView?
    @IBOutlet var hostName:UILabel?
    
    @IBOutlet var sponsorView:UIView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
    }
    
    func paintInterface() {
        
        self.separatorInset.bottom = 2
        self.selectionStyle = .none
        self.profileImage?.layer.borderWidth = UIDevice.current.userInterfaceIdiom == .pad ? 3:2
        self.profileImage?.layer.borderColor = UIColor.white.cgColor
        self.profileImage?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 3:2
        self.profileImage?.layer.masksToBounds = true
    }
    
    func paintGradientColorOnJoinSessionButton() {
        
        let reqLayer = CAGradientLayer()
        reqLayer.colors = [UIColor(red: 65.0/255.0, green: 166.0/255.0, blue: 248.0/255.0, alpha: 1).cgColor,UIColor(red: 100.0/255.0, green: 183.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor,UIColor(red: 148.0/255.0, green: 205.0/255.0, blue: 250.0/255.0, alpha: 1).cgColor]
        reqLayer.frame = self.joinButtonContainer?.bounds ?? CGRect.zero
        reqLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        reqLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.joinButtonLayerView?.layer.addSublayer(reqLayer)
        self.joinButtonContainer?.layer.cornerRadius = (self.joinButtonContainer?.frame.size.height ?? 0.0)/2
        self.joinButtonContainer?.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        paintGradientColorOnJoinSessionButton()
        
        self.contentView.dropShadow(color: UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1), opacity: 0.5, offSet: CGSize.zero, radius: UIDevice.current.userInterfaceIdiom == .pad ? 8:6, scale: true, layerCornerRadius: 0.0)
        
        mainView?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 6:4
        
        mainView?.layer.masksToBounds = true
        //self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    func fillInfo(info:EventSlotInfo?){
        
        guard let info = info else {
            return
        }
        self.info = info
        self.chatnumberLbl?.text = String(info.slotNo ?? 0)
        initializeDesiredDatesFormat(info:info)
        self.title?.text = "\(info.eventTitle ?? "")"
        self.hostName?.text = "\(info.callschedule?.user?.firstName ?? "")"
        
        if info.sponserId == nil{            
            self.sponsorView?.isHidden = true
        }else{
            self.sponsorView?.isHidden = false
        }
        
        if let bannerUrl = info.callschedule?.eventBannerUrl{
            if let url = URL(string:bannerUrl){
                
                profileImage?.sd_setImage(with: url, placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                })
                return
            }
            fetchProfileImage()
            return
        }
        fetchProfileImage()
    }
        
    func fetchProfileImage(){
        
        if let profileImage = info?.callschedule?.user?.profileImage{
            if let url = URL(string:profileImage){
                
                self.profileImage?.sd_setImage(with: url, placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                })
                return
            }
            return
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
            formattedStartTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm")
            formattedStartDate = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "EEE, MMM dd, yyyy")
            formattedStartTime = "\(formattedStartTime ?? "")-\(formattedEndTime ?? "") \(TimeZone.current.abbreviation() ?? "")"
        }
    }
    
    var _formattedEndTime:String?{
        
        get{
            
            return formattedEndTime ?? ""
        }
        set{
            
            let date = newValue
            formattedEndTime = DateParser.convertDateToDesiredFormat(date: date, ItsDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", requiredDateFormat: "h:mm a")
        }
    }
    
    func showAlert(sender:UIButton){
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update App", style: UIAlertAction.Style.default) { (success) in
            
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: "Continue to Session", style: UIAlertAction.Style.default) { (success) in
            
            self.delegate?.jointEvent(info:self.info)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) { (success) in
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
        delegate?.jointEvent(info:self.info)
    }
    
    @IBAction func systemTest(sender:UIButton?){
        
        delegate?.systemTest()
    }
}
