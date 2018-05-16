//
//  CalendarWrapper.swift
//  Chatalyze
//
//  Created by Mansa on 09/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarWrapper: ExtendedView {

    var root:GreetingDateTimeRootView?
    @IBOutlet var calendarView:JTAppleCalendarView?
    @IBOutlet weak var monthLabel: UILabel?
    var cc = Calendar(identifier: .gregorian)
    var prePostVisibility: ((CellState, CalendarCell?)->())?
    var layout = UICollectionViewFlowLayout()
    override func viewDidLayout() {
        super.viewDidLayout()
     
        setupLayout()
        self.calendarView?.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            //self.setupViewsOfCalendar(from: visibleDates)
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupancalender(){
        
        var cc = Calendar(identifier: .gregorian)
        cc.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.autoupdatingCurrent
        cc.locale = Locale(identifier: "en_US_POSIX")
    }
    
    func setupLayout(){
        
        self.calendarView?.minimumInteritemSpacing = 1
        self.calendarView?.minimumLineSpacing = 1
    }
    
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = cc.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = cc.component(.year, from: startDate)
        monthLabel?.text = monthName + " " + String(year)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CalendarWrapper{
    
    @IBAction func next(_ sender: UIButton) {
        self.calendarView?.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: UIButton) {
        self.calendarView?.scrollToSegment(.previous)
    }
}


extension CalendarWrapper:JTAppleCalendarViewDataSource,JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let myCustomCell = cell as! CalendarCell
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        
        //handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CalendarCell)
    }
    
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        
        guard let myCustomCell = view as? CalendarCell else {return }
        //        switch cellState.selectedPosition() {
        //        case .full:
        //            myCustomCell.backgroundColor = .green
        //        case .left:
        //            myCustomCell.backgroundColor = .yellow
        //        case .right:
        //            myCustomCell.backgroundColor = .red
        //        case .middle:
        //            myCustomCell.backgroundColor = .blue
        //        case .none:
        //            myCustomCell.backgroundColor = nil
        //        }
        //
        if cellState.isSelected {
            
        } else {
        }
    }
    
    
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let myCustomCell = view as? CalendarCell  else {
            return
        }
        
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth{
            
            myCustomCell.dayLabel?.textColor = UIColor.white
            myCustomCell.selectedView?.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                
                myCustomCell.dayLabel?.textColor = UIColor.white
                myCustomCell.selectedView?.backgroundColor = UIColor(red: 130.0/255.0, green: 197.0/255.0, blue: 126.0/255.0, alpha: 1)
                
            }else {
                myCustomCell.dayLabel?.textColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 1)
                
                myCustomCell.selectedView?.backgroundColor = UIColor.white
            }
        }
    }
    
    
    func configureVisibleCell(myCustomCell: CalendarCell, cellState: CellState, date: Date) {
        
        myCustomCell.dayLabel?.text = cellState.text
        if cc.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.red
        }else {
            myCustomCell.backgroundColor =  UIColor.white
        }
        
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        
        if cellState.text == "1" {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: date)
            myCustomCell.monthLabel?.text = "\(month) \(cellState.text)"
        } else {
            myCustomCell.monthLabel?.text = ""
        }
    }
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        var cc = Calendar(identifier: .gregorian)
        cc.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.autoupdatingCurrent
        cc.locale = Locale(identifier: "en_US_POSIX")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd hh:mm:ss Z"
        formatter.timeZone = cc.timeZone
        formatter.locale  = cc.locale
        
        let startDate = formatter.date(from: "2018 01 01 00:00:00 +0000")!
        let endDate = formatter.date(from: "2019 02 01 00:00:00 +0000")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate)
        return parameters
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        myCustomCell.dayLabel?.text = cellState.text
        return myCustomCell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        //print("I called")
        //print(cellState.date)
        //print(date)
        //E, d MMM yyyy
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.date(from: formatter.string(from: cellState.date))
        print(Date())
        print(formatter.date(from: formatter.string(from: cellState.date)))
        if cellState.dateBelongsTo == .thisMonth {
            handleCellConfiguration(cell: cell, cellState: cellState)
            return
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellConfiguration(cell: cell, cellState: cellState)
        return
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        self.setupViewsOfCalendar(from: visibleDates)
    }
}


