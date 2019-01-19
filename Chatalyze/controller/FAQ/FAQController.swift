//
//  FAQController.swift
//  Chatalyze
//
//  Created by Mansa on 05/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class FAQController: InterfaceExtendedController {

    @IBOutlet var influencerLbl:UILabel?
    @IBOutlet var fanLbl:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paintInterface()
        paintUILable()
        // Do any additional setup after loading the view.
    }
    
    func paintUILable(){
        
        var fontSize = 18
        var browserTextFontSize = 14
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSize = 26
            browserTextFontSize = 18
        }
        
        let firstText = "Hosts\n"
        let firstMutableAttributedStr = firstText.toMutableAttributedString(font: "Poppins", size: fontSize, color: UIColor.black)
        
        let secondStr =  "Browse FAQs"
        let secondAttributesStr = secondStr.toAttributedString(font: "Questrial", size: browserTextFontSize, color: UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:true)
        
        firstMutableAttributedStr.append(secondAttributesStr)
        
        influencerLbl?.attributedText = firstMutableAttributedStr
        
        let firstFanText = "Participants \n"
        let firstFanMutableAttributedStr = firstFanText.toMutableAttributedString(font: "Poppins", size: fontSize, color: UIColor.black)
        
        let secondFanStr =  "Browse FAQs"
        let secondFanAttributesStr = secondFanStr.toAttributedString(font: "Questrial", size: browserTextFontSize, color:UIColor(hexString:AppThemeConfig.themeColor),isUnderLine:true)
        
        firstFanMutableAttributedStr.append(secondFanAttributesStr)
        
        fanLbl?.attributedText = firstFanMutableAttributedStr
    }
    
    func paintInterface(){
        
        paintNavigationTitle(text: "FAQs")
        paintBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
    }
    
    @IBAction func influencerAction(){
        
        guard let controller = FAQWebController.instance() else{
            return
        }
        controller.url = "https://dev.chatalyze.com/faqs/influencer/app"
        controller.nameofTitle = "Host FAQs"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func fansAction(){
     
        guard let controller = FAQWebController.instance() else{
            return
        }
        controller.nameofTitle = "Participant FAQs"
        controller.url = "https://dev.chatalyze.com/faqs/fan/app"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*
     
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->FAQController?{
        
        let storyboard = UIStoryboard(name: "FAQ", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FAQ") as? FAQController
        return controller
    }
}
