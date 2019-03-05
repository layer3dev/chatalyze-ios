//
//  SignInLearnMoreController.swift
//  Chatalyze
//
//  Created by mansa infotech on 05/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class SignInLearnMoreController: InterfaceExtendedController {
    
    @IBOutlet var learnMoreLabel:UILabel?
    @IBOutlet var heightOfNavigationBarCustomView:NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLearnMoreLabel()
        hideNavigationBar()
        heightOfNavigationBarCustomView?.constant = topDistance
        Log.echo(key: "yud", text: "Top distance in view Did Load  \(topDistance)")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Log.echo(key: "yud", text: "Top distance in view Did Appear  \(topDistance)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLearnMoreLabel()
    }
    
    func updateLearnMoreLabel(){
        
        DispatchQueue.main.async {
            
            let firstStr = "Have specific questions? Feel free to "
            let firstMutableStr = firstStr.toMutableAttributedString(font: "OpenSans", size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, color: UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1), isUnderLine: false)
            
            let secondStr = "contact us"
            let secondAttrStr = secondStr.toAttributedString(font: "OpenSans", size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, color: UIColor(red: 175.0/255.0, green: 216.0/255.0, blue: 249.0/255.0, alpha: 1), isUnderLine: true)
            
            let thirdStr = ". We’ll be happy to help!"
            let thirdAttrStr = thirdStr.toAttributedString(font: "OpenSans", size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, color: UIColor(red: 126.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1), isUnderLine: false)
            
            firstMutableStr.append(secondAttrStr)
            firstMutableStr.append(thirdAttrStr)
            
            self.learnMoreLabel?.attributedText = firstMutableStr
        }
    }
    
    @IBAction func learnMoreAction(sender:UIButton){
                
        self.navigationController?.popViewController(animated: true)
        guard let controller = ContactUsWithoutUserIdController.instance() else{
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func backAction(sender:UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    public var topDistance : CGFloat{
       
        get{
            
            let barHeight = self.navigationController?.navigationBar.frame.height ?? 0
            //let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            return barHeight + statusBarHeight
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->SignInLearnMoreController?{
        
        let storyboard = UIStoryboard(name: "signin", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignInLearnMore") as? SignInLearnMoreController
        return controller
    }

}
