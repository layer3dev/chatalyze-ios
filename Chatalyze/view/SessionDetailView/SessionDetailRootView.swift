//
//  SessionDetailRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 25/01/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import Foundation

protocol SessionDetailRootViewDelegate {
    func getEmptySlots()->[EmptySlotInfo]?
}

class SessionDetailRootView: ExtendedView {
    
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var timeLbl:UILabel?
    @IBOutlet var title:UILabel?
    @IBOutlet var ticketsBooked:UILabel?
    @IBOutlet var priceLbl:UILabel?
    @IBOutlet var durationLbl:UILabel?
    private var info:EventInfo?
    var controller :SessionDetailController?
    @IBOutlet var heightOfAdapter:NSLayoutConstraint?
    @IBOutlet var slotListing:UITableView?
    var adpater = SessionDetailCellAdapter()
    @IBOutlet var cancelSessionView:UIView?
    var isCancelSessionVisible = false
    @IBOutlet var cancelItLbl:UILabel?
    var delegate:SessionDetailRootViewDelegate?
    @IBOutlet var goBackButtonContainer:UIView?
    @IBOutlet var confirmButton:UIButton?
    @IBOutlet var cancelView:ButtonContainerCorners?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        underLineCancelButton()
    }
    
    func paintInterface(){
        
        goBackButtonContainer?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ?  32.5 : 22.5
      
        confirmButton?.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ?  32.5 : 22.5
        
        goBackButtonContainer?.layer.masksToBounds = true
        confirmButton?.layer.masksToBounds = true
    }
    
    func initialize(){
     
        DispatchQueue.main.async {
        
            self.adpater.delegate = self
            self.adpater.initilaize(tableView:self.slotListing)
        }
    }
    
    func underLineCancelButton(){
        
        DispatchQueue.main.async {
            
            let text = "CANCEL IT"
            let attr = [NSAttributedString.Key.underlineStyle:NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            let attrStr = NSAttributedString(string: text, attributes: attr)
            self.cancelItLbl?.attributedText = attrStr
        }
    }
    
    func fillInfo(info:EventInfo?){
        
        DispatchQueue.main.async {
            
            guard let info = info  else {
                return
            }
            self.info = info
            self.reloadAdapter()
            
            Log.echo(key: "yud", text: " Time difference in between the end and current time \(Date().timeIntervalSince(info.endDate ?? Date()))")
            
            if Date().timeIntervalSince(info.endDate ?? Date()) > 0.0{
                self.cancelView?.isHidden = true
            }else{
                self.cancelView?.isHidden = false
            }
            
            if let title = info.title{
                self.title?.text = title
            }
            
            self.priceLbl?.text =  (info.price ?? 0.0)  == 0.0 ? "Free": "$\(String(format: "%.2f", info.price ?? 0.0)) per chat"
            self.durationLbl?.text = "\(Int(info.duration ?? 0.0)) min chats"

            if let startDate = info.startDate{
                if let endDate = info.endDate{
                    let timeDiffrence = endDate.timeIntervalSince(startDate)
                    Log.echo(key: "yud", text: "The total time of the session is \(timeDiffrence)")
                    if let durate  = info.duration{
                        let totalnumberofslots = Int(timeDiffrence/(durate*60))
                        self.ticketsBooked?.text = "\(info.callBookings.count) of \(totalnumberofslots) chats booked "
                    }
                }
            }
            self.setDate()
        }
    }
    
    func reloadAdapter(){
        
        adpater.initializeAdapter(emptySlotInfo:delegate?.getEmptySlots())
    }
    
    func setDate(){
        
        guard let info = self.info else {
            return
        }
        
        if let date = info.startDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            self.dateLbl?.text = "\(dateFormatter.string(from: date))"
        }
        
        if let date = info.startDate {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let requireOne = dateFormatter.string(from: date)
            
            if let date = info.endDate {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.locale = Locale.current
                dateFormatter.amSymbol = "am"
                dateFormatter.pmSymbol = "pm"
                self.timeLbl?.text = "\(requireOne) - \(dateFormatter.string(from: date)) \(TimeZone.current.abbreviation() ?? "")"
                Log.echo(key: "yud", text: "Locale abbrevation is")
            }
        }
    }
    
    @IBAction func menuAction(sender:UIButton){
        
        self.controller?.menuAction()
    }
    
    @IBAction func backButton(sender:UIButton){
        
        self.controller?.backAction()
    }
    
    
    @IBAction func cancelAction(sender:UIButton){
        
        if self.isCancelSessionVisible{
            
            self.layoutIfNeeded()
            self.isCancelSessionVisible = false
            UIView.animate(withDuration: 0.35) {
                self.cancelSessionView?.alpha = 0
            }
            return
        }
        
        self.isCancelSessionVisible = true
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.35) {
            self.cancelSessionView?.alpha = 1
        }
        return
    }
    
    @IBAction func keepITAction(sender:UIButton){
        
        self.layoutIfNeeded()
        self.isCancelSessionVisible = false
        UIView.animate(withDuration: 0.35) {
            self.cancelSessionView?.alpha = 0
        }
        return
    }
    
    @IBAction func cancelITAction(sender:UIButton){
        
        self.controller?.cancelSession()
        //service for cancel Session
    }
    
}

extension SessionDetailRootView:SessionDetailCellAdapterProtocols{
    
    func tableViewRefrence() -> UITableView? {
        
        return self.slotListing
    }
    
    func updateUI(height: CGFloat){
       
        DispatchQueue.main.async {
            self.heightOfAdapter?.constant = height
        }
    }
}
