//
//  GreetingDateTimeRootView.swift
//  Chatalyze
//
//  Created by Mansa on 07/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class GreetingDateTimeRootView: ExtendedView {
    
    fileprivate var adapter  = GreetingDateTimeAdapter()
    var controller:GreetingDateTimeController?
    
    @IBOutlet var timePicker:UIDatePicker?
    @IBOutlet var timeLable:UILabel?
    
    @IBOutlet var dateHeightContraint:NSLayoutConstraint?
    @IBOutlet var timeHeightContraint:NSLayoutConstraint?
    
    @IBOutlet var calendarView:CalendarWrapper?
    @IBOutlet var nextButtonContainerView:UIView?
    
    var info:GreetingInfo?    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        paintInterface()
        initializeVariable()
    }
    
    func initializeVariable(){
        
        self.timeLable?.text = selectedTime
        //calendarView?.root = self
    }
    
    func paintInterface(){
        
        nextButtonContainerView?.layer.cornerRadius = 3
        nextButtonContainerView?.layer.masksToBounds = true
    }
    
    @IBAction func timePickerAction(_ sender: Any) {
        
        self.timeLable?.text = selectedTime
    }
    
    var selectedTime:String{
        get{            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = Locale.current.languageCode == "en" ? "h:mm a" : Locale.current.languageCode == "th" ? "H.mm" : "H:mm"
            if let cd  = timePicker?.date{
                return dateFormatter.string(from: cd)
            }
            return ""
        }
    }
    
    
    @IBAction func dateAction(sender:UIButton){
        
        UIView.animate(withDuration: 0.3) {
            
            if self.dateHeightContraint?.constant == 0{
                
                self.dateHeightContraint?.constant = 400
                self.timeHeightContraint?.constant = 0
                self.controller?.updateViewConstraints()
                self.layoutIfNeeded()
                return
            }
            self.dateHeightContraint?.constant = 0
            self.controller?.updateViewConstraints()
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func timeAction(sender:UIButton){
        
        UIView.animate(withDuration: 0.3) {
          
            if self.timeHeightContraint?.constant == 0{
                
                self.timeHeightContraint?.constant = 180
                self.dateHeightContraint?.constant = 0
                self.controller?.updateViewConstraints()
                self.layoutIfNeeded()
                return
            }
            self.timeHeightContraint?.constant = 0
            self.controller?.updateViewConstraints()
            self.layoutIfNeeded()
        }
    }
    
    func updateDate(date:Date?){
    }
    
    @IBAction func nextAction(sender:UIButton){
        
        guard let controller = GreetingrecipientController.instance() else {
            return
        }
        
        controller.info = self.info
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }    
}
