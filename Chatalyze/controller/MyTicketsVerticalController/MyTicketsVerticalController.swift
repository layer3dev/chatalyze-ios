//
//  MyTicketsVerticalController.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class MyTicketsVerticalController: MyTicketsController{
    
    var fontSize:CGFloat = 16.0
    @IBOutlet var underLineLbl:UILabel?
   
    @IBOutlet var showView:UIView?
    var isShow = false
    
    //Implementing the eventDeleteListener
    var eventDeleteListener = EventDeletedListener()
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeFontSize()
        underLineLable()
        getTheRequiredDate()
        initializeListenrs()
    }
    
    
    func initializeListenrs(){
        
        eventDeleteListener.setListener { (deletedEventID) in
            
            Log.echo(key: "yud", text: "Got the deleted event")
            
            for events in self.ticketsArray{
                
                Log.echo(key: "yud", text: "Matched Event Id is \(events.callschedule?.id ?? 0) and coming from server is \(Int(deletedEventID ?? "0"))")
                
                if events.callschedule?.id ?? 0 == Int(deletedEventID ?? "0"){
                    
                    //self.exitAction()
                    Log.echo(key: "yud", text: "Yes I got matched \(deletedEventID)")
                }
            }
        }
    }
    
    @IBAction func animateInfo(){
        
        if isShow{
            
            isShow = false
            UIView.animate(withDuration: 0.35) {
                self.showView?.alpha = 0
                self.view.layoutIfNeeded()
            }
            return
        }
        isShow = true
        UIView.animate(withDuration: 0.35) {
            self.showView?.alpha = 1
            self.view.layoutIfNeeded()
        }
        return
    }
    
    
    @IBAction func  disableInfoAction(){
     
        isShow = false
        UIView.animate(withDuration: 0.35) {
            self.showView?.alpha = 0
            self.view.layoutIfNeeded()
        }
        return
    }
    
    func getTheRequiredDate(){
    
        let dateFormatter = DateFormatter()
        
//        dateFormatter.timeZone = TimeZone.init(abbreviation: "GMT")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
//        print("Required date is \(dateFormatter.date(from: "Thu, 25 Oct 2018 11:20:15 GMT"))")
        
        let date = Date()
        
        //dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //let str = dateFormatter.string(from: date)
        //print("String date is \(dateFormatter.string(from: date))")
        
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "E, d MMM yyyy "
        
        print("Extented date is \(dateFormatter.string(from: date))")
        print("Date from str is  \(dateFormatter.date(from: "Thu, 25 Oct 2018 11:20:15 GMT"))")
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        
        var testingText = "TEST MY PHONE"
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            testingText = "TEST MY IPAD"
        }
        
        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)] as? [NSAttributedString.Key : Any]{

            
            let underlineAttributedString = NSAttributedString(string: testingText, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            
            underLineLbl?.attributedText = underlineAttributedString
        }
    }

    
    @IBAction func systemTest(){
      
        guard let controller = InternetSpeedTestController.instance() else{
            return
        }
        controller.onlySystemTest = true
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override class func instance()->MyTicketsVerticalController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyTicketsVertical") as? MyTicketsVerticalController
        return controller
    }
}


