//
//  MySessionTableViewCell.swift
//  Chatalyze
//
//  Created by Mansa on 01/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MySessionTableViewCell: ExtendedTableCell {
    
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var ticketsBooked:UILabel?
    var info:EventInfo?
    var enterSession:((EventInfo?)->())?
    @IBOutlet var sessionEventButton:UIButton?
    @IBOutlet var joinButton:UIButton?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            joinButton?.layer.cornerRadius = 5
            joinButton?.layer.masksToBounds = true
            return
        }
        joinButton?.layer.cornerRadius = 3
        joinButton?.layer.masksToBounds = true
    }
    
    func fillInfo(info:EventInfo?){
        
        guard let info = info  else {
            return
        }
        self.info = info
        if let title = info.title{
            
            self.title?.text = title
        }
        
        if let startDate = info.startDate{
            if let endDate = info.endDate{
                let timeDiffrence = endDate.timeIntervalSince(startDate)
                Log.echo(key: "yud", text: "The total time of the session is \(timeDiffrence)")
                if let durate  = info.duration{
                    let totalnumberofslots = Int(timeDiffrence/(durate*60))
                    self.ticketsBooked?.text = "\(info.callBookings.count) of \(totalnumberofslots) "
                }
            }
        }
        setDate()
        paintEnterSession()
    }
    func paintEnterSession(){
        
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0{
            
            //Event is not started yet
            self.sessionEventButton?.backgroundColor = UIColor(red: 240.0/255.0, green: 241.0/255.0, blue: 245.0/255.0, alpha: 1)
           self.sessionEventButton?.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
            return
        }
        self.sessionEventButton?.backgroundColor = UIColor(hexString: AppThemeConfig.themeColor) 
       
        self.sessionEventButton?.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func setDate(){
        
        guard let info = self.info else{
            return
        }
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, MMM dd"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.dateLbl?.text = "\(dateFormatter.string(from: date))"
        }
        
        if let date = info.startDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.timeLbl?.text = dateFormatter.string(from: date)
            //self.timeLbl?.text = "dfhiadshfjkhdjksfhjkadhsfjkhadjkshfjkadhsjkfhjkasdhfjkhasdjkfhjkadshjkfhadsjkhfjadhsjkfhjkadshfjkdhsjkfhdjkshf"
        }
    }
    
    func showAlert(sender:UIButton){
        
        let alertMessage = HandlingAppVersion().getAlertMessage()
        
        let alertActionSheet = UIAlertController(title: AppInfoConfig.appName, message: alertMessage, preferredStyle: UIAlertController.Style.actionSheet)
        
        let uploadAction = UIAlertAction(title: "Update App", style: UIAlertAction.Style.default) { (success) in
            HandlingAppVersion.goToAppStoreForUpdate()
        }
        
        let callRoomAction = UIAlertAction(title: "Continue to Session", style: UIAlertAction.Style.default) { (success) in
            
            self.gotoSession()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) { (success) in
        }
        
        
        alertActionSheet.addAction(uploadAction)
        alertActionSheet.addAction(callRoomAction)
        alertActionSheet.addAction(cancel)
        
        //alertActionSheet.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        if let presenter = alertActionSheet.popoverPresentationController {
            
            alertActionSheet.popoverPresentationController?.sourceView =                 RootControllerManager().getCurrentController()?.view
            alertActionSheet.popoverPresentationController?.sourceRect = sender.frame
        }
        
        RootControllerManager().getCurrentController()?.present(alertActionSheet, animated: true) {
        }
        //self.root?.controller?.present
    }
    
    

    
    func gotoSession(){
        
        if (self.info?.startDate?.timeIntervalSince(Date()) ?? 0.0) > 1800.0{
            
            Log.echo(key: "yud", text: "You'll be able to enter your session 30 minutes before it starts")
            
            RootControllerManager().getCurrentController()?.alert(withTitle: AppInfoConfig.appName, message: "You'll be able to enter your session 30 minutes before it starts", successTitle: "OK", rejectTitle: "Cancel", showCancel: false, completion: { (success) in
                
                self.enterSession?(nil)
            })
            return
        }
        
        if let session = enterSession{
            session(self.info)
        }
    }
    
    
    @IBAction func enterSessionAction(sender:UIButton?){
        
        if HandlingAppVersion().getAlertMessage() != "" {
            showAlert(sender: sender ?? UIButton())
            return
        }
        self.gotoSession()
    }
}
