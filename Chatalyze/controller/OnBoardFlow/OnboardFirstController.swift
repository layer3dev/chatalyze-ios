//
//  OnboardFirstController.swift
//  Chatalyze
//
//  Created by Mansa on 21/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class OnboardFirstController: InterfaceExtendedController {
    
    @IBOutlet var infoLbl:UILabel?
    var headingFontSize = 22
    var subHeadingFontSize = 18

//    enum controllerObjectIndex:Int{

//        case first  =  0
//        case second =  1
//        case third  =  2
//        case fourth =  3
//        case fifth  =  4
//    }
    
    
    var hostHeadingTextArray = ["Welcome to Chatalyze \n","Schedule a Session \n","Share Your Page \n","Countdown \n","Chat \n"]
    
    var hostSubHeadingTextArray = ["Tap the big blue button in My Sessions to get started.","Set a date, start time, duration, 1:1 chat length, and price.","Post the link to your booking page so people can reserve chat slots.","After entering your session, you'll see a countdown to its start time.","We'll connect you to each person in the video chat queue, one-by-one."]

    var userHeadingTextArray = ["Book a Chat\n","Receive a Ticket\n","Countdown\n","Chat\n"]
    var userSubHeadingTextArray = ["Find a host's booking page on their social channels and book a chat.","Your ticket gets you into your chat when it comes time.","After joining your chat, you'll see a countdown to its start time.","When the countdown hits zero, you'll automatically connect to your chat!"]
    
    
    var hostImageArray = ["hostPageOne","hostPageTwo","hostPageThree","hostPageThree","hostPageFive"]
    var userImageArray = ["userPageOne","userPageTwo","userPageThree","userPageFour"]
    
    var currentControllerIndex = OnBoardPageViewController.controllerObjectIndex.first
    
    @IBOutlet var onBoardImage:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewTag()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            headingFontSize = 28
            subHeadingFontSize = 24
        }
        paintLableText()
        paintImage()
        paintBackgrounDColor()
        // Do any additional setup after loading the view.
    }
    
    func paintImage(){
        
        onBoardImage?.image = UIImage(named: getImage())
    }
    
    func paintBackgrounDColor(){
        
        //97CEFA
        //FAA579
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return
        }
        
        if userType == .analyst{
            
            if currentControllerIndex == .first{
            
                self.view.backgroundColor = UIColor(hexString: "#97cefa")
                return
            }
            if currentControllerIndex == .second{
                
                self.view.backgroundColor = UIColor(hexString: "#FAA579")
                return
            }
            if currentControllerIndex == .third{
                
                self.view.backgroundColor = UIColor(hexString: "#97cefa")
                return
            }
            if currentControllerIndex == .fourth{
                
                self.view.backgroundColor = UIColor(hexString: "#FAA579")
                return
            }
            if currentControllerIndex == .fifth{
                
                self.view.backgroundColor = UIColor(hexString: "#97cefa")
                return
            }
            
            return
        }
        
        if userType == .user{
            
            if currentControllerIndex == .first{
                
                self.view.backgroundColor = UIColor(hexString: "#97cefa")
                return
            }
            if currentControllerIndex == .second{
                
                self.view.backgroundColor = UIColor(hexString: "#FAA579")
                return
            }
            if currentControllerIndex == .third{
                
                self.view.backgroundColor = UIColor(hexString: "#97cefa")
                return
            }
            if currentControllerIndex == .fourth{
                
                self.view.backgroundColor = UIColor(hexString: "#FAA579")
                return
            }
            return
        }
        return
    }
    
    
    
    func initializeViewTag(){
        
        //View's Tags is responsible for getting the current index of the Controller in the DidFinishAnimation of ApgeViewController
        
        if currentControllerIndex == OnBoardPageViewController.controllerObjectIndex.first{
            
            self.view.tag = 0
            return
        }
        if currentControllerIndex == OnBoardPageViewController.controllerObjectIndex.second{
            
            self.view.tag = 1
            return
        }
        if currentControllerIndex == OnBoardPageViewController.controllerObjectIndex.third{
            
            self.view.tag = 2
            return
        }
        if currentControllerIndex == OnBoardPageViewController.controllerObjectIndex.fourth{
            
            self.view.tag = 3
            return
        }
        if currentControllerIndex == OnBoardPageViewController.controllerObjectIndex.fifth{
            
            self.view.tag = 4
            return
        }
    }
    
    func getImage()->String{
      
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return ""
        }
        
        if userType == .analyst{
            
            if currentControllerIndex == .first{
                
                return hostImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return hostImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return hostImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return hostImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fifth{
                
                return hostImageArray[currentControllerIndex.rawValue]
            }
            
            return ""
        }
        
        if userType == .user{
            
            if currentControllerIndex == .first{
                
                return userImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return userImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return userImageArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return userImageArray[currentControllerIndex.rawValue]
            }
            return ""
        }
        return ""
        
    }
    
    func getHeadingText()->String{
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return ""
        }
        
        if userType == .analyst{
            
            if currentControllerIndex == .first{
                
                return hostHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return hostHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return hostHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return hostHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fifth{
                
                return hostHeadingTextArray[currentControllerIndex.rawValue]
            }
            
            return ""
        }
        
        if userType == .user{
            
            if currentControllerIndex == .first{
                
                return userHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return userHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return userHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return userHeadingTextArray[currentControllerIndex.rawValue]
            }
            return ""
        }
        return ""
    }
    
    func getSubHeadingText()->String{
        
        guard let userType = SignedUserInfo.sharedInstance?.role else{
            return ""
        }
        
        if userType == .analyst{
            
            
            if currentControllerIndex == .first{
                
                return hostSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return hostSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return hostSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return hostSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fifth{
                
                return hostSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            
            return ""
        }
        
        if userType == .user{
            
            
            if currentControllerIndex == .first{
                
                return userSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .second{
                
                return userSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .third{
                
                return userSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            if currentControllerIndex == .fourth{
                
                return userSubHeadingTextArray[currentControllerIndex.rawValue]
            }
            return ""
        }
        return ""
        
    }
    
    func paintLableText(){
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            Log.echo(key: "yud", text: "Family: \(family) Font names: \(names))")
        }
        
        let firstText = getHeadingText()
        let scecondStr = getSubHeadingText()
        
        if firstText == "" || scecondStr == "" {
            //Case of  Error
            return
        }
        
        
        
        let firstMutableStr = firstText.toMutableAttributedString(font: "OpenSans-SemiBold", size: headingFontSize, color: UIColor.white, isUnderLine: false)
        
        
        let secondAtrStr = scecondStr.toAttributedString(font: "Open Sans", size: subHeadingFontSize, color: UIColor.white, isUnderLine: false)
        
        firstMutableStr.append(secondAtrStr)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 6
        
        paragraphStyle.alignment = .center
        
        firstMutableStr.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, firstMutableStr.length))
        
        infoLbl?.textAlignment = .center

        infoLbl?.attributedText = firstMutableStr
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    class func instance()->OnboardFirstController?{
        
        let storyboard = UIStoryboard(name: "OnBoardingFlow", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OnboardFirst") as? OnboardFirstController
        return controller
    }

}
