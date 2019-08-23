//
//  TestController.swift
//  Chatalyze
//
//  Created by mansa infotech on 10/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import FSCalendar

class TestController: UIViewController {

    @IBOutlet var rotationalView:UIView?
    @IBOutlet var mainImageView:UIImageView?
    @IBOutlet var calendarNew:FSCalendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fontSizeHeader:CGFloat = 20
        var fontSizeText:CGFloat = 16
        var headerHeight:CGFloat = 60
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSizeHeader = 26
            fontSizeText = 20
            headerHeight = 80
        }
        
        self.rotationalView?.rotate(angle: -10)
        self.calendarNew?.delegate = self
        self.calendarNew?.dataSource = self
        self.calendarNew?.appearance.headerTitleFont = UIFont(name: "Nunito-Bold", size: fontSizeHeader)
        self.calendarNew?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.titleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.weekdayFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.headerHeight = headerHeight
        // Do any additional setup after loading the view.
    }
}

extension TestController:FSCalendarDataSource,FSCalendarDelegate{
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        Log.echo(key: "yud", text: "Selected date is \(date)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.current
        formatter.locale = NSLocale.current
        Log.echo(key: "yud", text: "String is \(formatter.string(from: date))")
    }
    
    func previousMonth(){
        calendarNew?.setCurrentPage(getPreviousMonth(date:calendarNew?.currentPage ?? Date()), animated: true)
    }
    
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func nextMonth(){
        
        calendarNew?.setCurrentPage(getNextMonth(date:calendarNew?.currentPage ?? Date()), animated: true)
    }
    
    @IBAction func nextAction(sender:UIButton?){
       
        self.nextMonth()
    }
    
    @IBAction func previousAction(sender:UIButton?){
        
        self.previousMonth()
    }
}


extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}

