//
//  PostChatFeedbackController.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 04/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit
import WebKit

class PostChatFeedbackController: InterfaceExtendedController {
    
  
    @IBOutlet weak var webview : WKWebView?
    var htmlData : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        loadwebViewContent()
    }
    
  
    
    func initialization(){
        paintInterface()
    }
    
    func paintInterface(){
        paintNavigationTitle(text: "PostChatfeedback")
    }

    
    func loadwebViewContent(){
        
        guard let htmlString = self.htmlData else {
            return
        }
        webview?.loadHTMLString(htmlString, baseURL: nil)
    }

}

extension PostChatFeedbackController {
    class func instance()->PostChatFeedbackController?{
        
        let storyboard = UIStoryboard(name: "feedback", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostChatFeedbackController") as? PostChatFeedbackController
        return controller
    }
}
