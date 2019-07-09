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
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSizeHeader = 26
            fontSizeText = 20
        }
        
        self.rotationalView?.rotate(angle: -10)
        self.calendarNew?.delegate = self
        self.calendarNew?.dataSource = self
        self.calendarNew?.appearance.headerTitleFont = UIFont(name: "Nunito-Bold", size: fontSizeHeader)
        self.calendarNew?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.titleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.weekdayFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.appearance.subtitleFont = UIFont(name: "Nunito-Bold", size: fontSizeText)
        self.calendarNew?.headerHeight = 75.0
        
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
}


extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Test", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}

