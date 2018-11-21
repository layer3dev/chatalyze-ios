//
//  TermsConditionController.swift
//  Chatalyze
//
//  Created by Mansa on 08/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class TermsConditionController: InterfaceExtendedController,UIWebViewDelegate {

    @IBOutlet var webView:UIWebView?
    var url = ""
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        webView?.delegate = self
        loadUrl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.stopLoader()
        }
    }
    
    
    @IBAction func dismissController(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadUrl(){
                
        if let url = URL(string: self.url) {

            let requestedUrl = URLRequest(url: url as URL)
            webView?.loadRequest(requestedUrl)
        }

//        if let abc = Bundle.main.path(forResource: "chatalyze_terms_html", ofType: "html"){
//
//            if let html = try? String(contentsOfFile: abc , encoding: String.Encoding.utf8){
//                webView?.loadHTMLString(html, baseURL: nil)
//            }
//        }
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        self.showLoader()
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.stopLoader()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.stopLoader()
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->TermsConditionController?{
        
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TermsCondition") as? TermsConditionController
        return controller
    }
}

extension TermsConditionController{
}
