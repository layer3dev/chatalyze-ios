//
//  PostChatFeedbackController.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 04/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

class PostChatFeedbackController: InterfaceExtendedController {
    
  
    @IBOutlet weak var webview : WKWebView?
    @IBOutlet weak var baclkgroundImg : UIImageView?
    
    var htmlData : String?
    var backgrndImgUrl : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        loadwebViewContent()
        setBackGrndImg()
    }
    
  
    
    func initialization(){
        paintInterface()
    }
    
    func paintInterface(){
        paintNavigationTitle(text: "")
        
        let leftBarButtonItem = UIBarButtonItem(title: "X", style: .done, target: self, action: #selector(dismissViewController))
        leftBarButtonItem.tintColor = .white
        
         self.navigationItem.rightBarButtonItem = leftBarButtonItem
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = []
        
        self.webview?.isOpaque = false
        self.webview?.backgroundColor = UIColor.clear
          
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationItem.hidesBackButton = true
    }

    
    func loadwebViewContent(){
        
        guard let htmlString = self.htmlData else {
            return
        }
        webview?.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
    func setBackGrndImg(){
        if let imgUrl = self.backgrndImgUrl{
            SDWebImageDownloader().downloadImage(with: URL(string: imgUrl), completed: { (image, data, error, success) in
                if let img = image{
                    self.baclkgroundImg?.image = img
                    self.baclkgroundImg?.contentMode = .scaleToFill
                }
            })
        }
    }
    
    @objc private func dismissViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }


}

extension PostChatFeedbackController {
    class func instance()->PostChatFeedbackController?{
        
        let storyboard = UIStoryboard(name: "feedback", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PostChatFeedbackController") as? PostChatFeedbackController
        return controller
    }
}
