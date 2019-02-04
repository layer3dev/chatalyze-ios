//
//  FAQWebController.swift
//  Chatalyze
//
//  Created by Mansa on 05/11/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class FAQWebController:TermsConditionController  {
    
    var nameofTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        paintInterface()
        // Do any additional setup after loading the view.
    }
    
    func paintInterface(){
        
        paintBackButton()
        paintNavigationTitle(text: nameofTitle)
        headerLabel?.text = nameofTitle
    }
    
    
//    override func loadUrl() {
//
//        if let url = URL(string: self.url) {
//
//            let requestedUrl = URLRequest(url: url as URL)
//            webView?.loadRequest(requestedUrl)
//        }
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override class func instance()->FAQWebController?{
        
        let storyboard = UIStoryboard(name: "FAQ", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FAQWeb") as? FAQWebController
        return controller
    }

}
