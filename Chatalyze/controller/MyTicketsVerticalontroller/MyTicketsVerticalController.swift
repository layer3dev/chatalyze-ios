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
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeFontSize()
        underLineLable()
    }
    
    func initializeFontSize(){
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 22.0
        }else{
            fontSize = 16.0
        }
    }
    
    func underLineLable(){
        

        if let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.font:UIFont(name: "Questrial", size: fontSize)] as? [NSAttributedString.Key : Any]{

            
            let underlineAttributedString = NSAttributedString(string: "TEST MY PHONE", attributes: underlineAttribute as [NSAttributedString.Key : Any])
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
