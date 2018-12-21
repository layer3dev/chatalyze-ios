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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tag = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            headingFontSize = 28
            subHeadingFontSize = 24
        }
        paintLableText()
        // Do any additional setup after loading the view.
    }
    
    func paintLableText(){
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            Log.echo(key: "yud", text: "Family: \(family) Font names: \(names))")
            
        }
        
        let firstText = "Welcome to the Chatalyze \n"
        let firstMutableStr = firstText.toMutableAttributedString(font: "OpenSans-SemiBold", size: headingFontSize, color: UIColor.white, isUnderLine: false)
        
        let scecondStr = "Tap the big blue button in My Sessions to get started."
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
