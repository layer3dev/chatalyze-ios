//
//  SessionDoneController.swift
//  Chatalyze
//
//  Created by Mansa on 22/08/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class SessionDoneController: InterfaceExtendedController {
    
    @IBOutlet var linkLbl:UILabel?
    var delegate:SessionDoneControllerProtocol?
    var param = [String:Any]()
    var eventInfo:EventInfo?
    
    override func viewDidLoad(){
        super.viewDidLoad()
     
        paintInterFace()
        initializeVariable()
        //Do any additional setup after loading the view.
    }
    
    func initializeVariable(){
        
        rootView?.controller = self
        rootView?.param = self.param
        updateLabelUrl()
    }
    
    func fillParam(param:[String:Any]){
       
        self.param = param
        rootView?.param = self.param
    }
    
    func paintInterFace(){
        
        paintHideBackButton()
    }
    
    @IBAction func backToMyAccountAction(sender:UIButton?){
        
        delegate?.backToAccount()
    }

    var rootView:SessionDoneRootView?{
        
        get{
            return self.view as? SessionDoneRootView
        }
    }
    
    func updateLabelUrl(){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        
        var str = "https://chatalyze.com/"
        str = str + "sessions/"
        str = str + (self.eventInfo?.title ?? "")
        str = str + "/"
        str = str + "\(id)"
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        var fontSize  = 16
        if UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 20
        }
        let attrStr = str.toAttributedString(font: "Poppins", size: fontSize, color: UIColor(hexString: "#faa579"), isUnderLine: true)
        linkLbl?.attributedText  = attrStr
        
        let linkGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnLink))
      
        linkGesture.delegate = self
        
        self.linkLbl?.addGestureRecognizer(linkGesture)
        
    }
    
    @objc func tapOnLink(recognizer:UITapGestureRecognizer){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        
        var str = "https://chatalyze.com/"
        str = str + "sessions/"
        str = str + (self.eventInfo?.title ?? "")
        str = str + "/"
        str = str + "\(id)"
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        
        if let url = URL(string: str){          
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func share(sender:UIButton){
        
        Log.echo(key: "yud", text: "EventInfo is not nil \(eventInfo?.id) and eventInfo Title is \(eventInfo?.title)")
         Log.echo(key: "yud", text: "info are \(self.eventInfo?.id) and the url is \(self.eventInfo?.title)")

        guard let id = self.eventInfo?.id else{
            return
        }

        var str = "https://chatalyze.com/"
        str = str + "sessions/"
        str = str + (self.eventInfo?.title ?? "")
        str = str + "/"
        str = str + "\(id)"
        Log.echo(key: "yud", text: "url id is \(str)")
        str  = str.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: str) {

            Log.echo(key: "yud", text: "Successfully converted url \(str)")

            if UIDevice.current.userInterfaceIdiom == .pad{

                let shareText = "Chatalyze"
                let shareItems: [Any] = [url,shareText]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = sender.frame
                self.present(activityVC, animated: false, completion: nil)

            }else{

                let shareText = "Chatalyze"
                let shareItems: [Any] = [url, shareText]
                let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                self.present(activityVC, animated: false, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SessionDoneController{
    
    class func instance()->SessionDoneController?{
        
        let storyboard = UIStoryboard(name: "ScheduleSession", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SessionDone") as? SessionDoneController
        return controller
    }
}
