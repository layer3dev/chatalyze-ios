//
//  OnboardThirdController.swift
//  Chatalyze
//
//  Created by Mansa on 21/12/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class OnboardThirdController: UIViewController {
   
    @IBOutlet var infoLbl:UILabel?
    
    var headingFontSize = 22
    var subHeadingFontSize = 18
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tag = 2
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            headingFontSize = 26
            subHeadingFontSize = 22
        }
        paintLableText()
        // Do any additional setup after loading the view.
    }
    
    func paintLableText(){
        
        let firstText = "Share Your Page \n"
        let firstMutableStr = firstText.toMutableAttributedString(font: "Nunito-SemiBold", size: headingFontSize, color: UIColor.white, isUnderLine: false)
        
        let scecondStr = "Post the link to your booking page so people can reserve chat slots."
        let secondAtrStr = scecondStr.toAttributedString(font: "Nunito-Regular", size: subHeadingFontSize, color: UIColor.white, isUnderLine: false)
        
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

    class func instance()->OnboardThirdController?{
        
        let storyboard = UIStoryboard(name: "OnBoardingFlow", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OnboardThird") as? OnboardThirdController
        return controller
    }

    
}
