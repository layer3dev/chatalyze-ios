//
//  FSWrapper.swift
//  Chatalyze
//
//  Created by Mac mini ssd on 10/07/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import FSCalendar

class FSWrapper: ExtendedView {

    @IBOutlet private var calendar:FSCalendar?
    var selectedDate:Date?{
        return calendar?.currentPage
    }
    
    var tappedDate:((Date?,String?)->())?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(hexString: "DBDBDB").cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    private func initialize(){
        
        var fontSizeHeader:CGFloat = 20
        var fontSizeText:CGFloat = 16
        var headerHeight:CGFloat = 50
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSizeHeader = 26
            fontSizeText = 20
            headerHeight = 80
        }
        
        self.calendar?.delegate = self
        self.calendar?.dataSource = self
        self.calendar?.appearance.headerTitleFont = UIFont(name: "Nunito-Bold", size: fontSizeHeader)
        self.calendar?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendar?.appearance.titleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendar?.appearance.weekdayFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendar?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        calendar?.appearance.caseOptions = .weekdayUsesSingleUpperCase
        self.calendar?.headerHeight = headerHeight

        // Do any additional setup after loading the view.
    }
    
}

extension FSWrapper:FSCalendarDataSource,FSCalendarDelegate{
    

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        Log.echo(key: "yud", text: "Selected date is \(date)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.current
        formatter.locale = NSLocale.current
        self.tappedDate?(date,formatter.string(from: date))
        Log.echo(key: "yud", text: "String is \(formatter.string(from: date))")
    }
    
    
    func setSelectionDate(date:Date?){
        
        guard let date = date else{
            return
        }
        
        calendar?.select(date, scrollToDate: true)
    }
    
    private func previousMonth(){
        
        calendar?.setCurrentPage(getPreviousMonth(date:calendar?.currentPage ?? Date()), animated: true)
    }
    
    
    private func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
     private func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
     private func nextMonth(){
        
        calendar?.setCurrentPage(getNextMonth(date:calendar?.currentPage ?? Date()), animated: true)
    }
    
    @IBAction private func nextAction(sender:UIButton?){
        
        self.nextMonth()
    }
    
    @IBAction private func previousAction(sender:UIButton?){
        
        self.previousMonth()
    }
}
