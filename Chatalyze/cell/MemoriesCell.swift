
//
//  MemoriesCell.swift
//  Chatalyze
//
//  Created by Mansa on 19/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import FBSDKShareKit
import FacebookShare
import TwitterKit
import TwitterShareExtensionUI
import TwitterCore

class MemoriesCell: ExtendedTableCell {
    
    @IBOutlet var orderIdLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var amountLbl:UILabel?
    @IBOutlet var orderType:UILabel?
    @IBOutlet var cardView:UIView?
    @IBOutlet var memoryImage:UIImageView?
    var controller:MemoriesController?
    var info:MemoriesInfo?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
        cardView?.layer.cornerRadius = 5
        cardView?.layer.masksToBounds = true
        cardView?.layer.borderWidth = 1
        cardView?.layer.borderColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1).cgColor
    }
    
    func fillInfo(info:MemoriesInfo?){
        
        guard let info = info else{
            return
        }
        self.info = info
        memoryImage?.image = UIImage(named: "base")
        if let imageStr = info.screenShotUrl{
            if let url = URL(string: imageStr){
                memoryImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                })
            }
        }
    }
    
    @IBAction func twitterShareAction(sender:UIButton){
        login()
        return
            return
        twitterSharing()
    }
    
    @IBAction func facebookShare(sender:UIButton){        
        
        guard let id = self.info?.id else{
            return
        }
        
        var url = "https://dev.chatalyze.com/api/screenshots/"
        url = url+id
        url = url+"/url/chatalyze.png"
        Log.echo(key: "yud", text: "Image url is \(url)")
        
        do{
            guard let image1 = self.memoryImage?.image else{
                return
            }
            let photo = Photo(image: image1, userGenerated: true)
            var contentImage = PhotoShareContent(photos: [photo])
            contentImage.url = URL(string: url)
            do{
                guard let controller = self.controller else {
                    return
                }
                try ShareDialog.show(from: controller, content: contentImage) { (result) in
                }
            }catch{
                
                let alert = UIAlertController(title: AppInfoConfig.appName, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                }))
                
                self.controller?.present(alert, animated: true, completion: {
                })
            }
        }catch{
            print("Unable to load data: \(error)")
        }
    }
    
    @IBAction func saveImageInGallery(sender:UIButton){
        
        self.saveImage()
    }
    
    func twitterSharing(){
        
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            
            //Image must have less than five mb.
            // App must have at least one logged-in user to compose a Tweet
            
            let composer = TWTRComposerViewController(initialText: "Hey this is my new tweet", image: UIImage(named: "base"), videoData: nil)
            
            RootControllerManager().getCurrentController()?.present(composer, animated: true, completion: nil)
        } else {
            
            // Log in, and then check again
            TWTRTwitter.sharedInstance().logIn { session, error in
                
                if session != nil {
                    
                    // Log in succeeded
                    let composer = TWTRComposerViewController(initialText: "Hey this is my new tweet ", image: UIImage(named: "base"), videoData: nil)
                    RootControllerManager().getCurrentController()?.present(composer, animated: true, completion: nil)                    
                } else {
                    
                    //                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                    //                    RootControllerManager().getCurrentController()?.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    
    func login() {
        
        TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
            
            if let error = error, let weakSelf = self {
                
                let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action) in
                    RootControllerManager().getCurrentController()?.dismiss(animated: true, completion: {
                        
                    })
                })
                alert.addAction(okAction)
                RootControllerManager().getCurrentController()?.present(alert, animated: false, completion: nil)
                
            } else if let session = session, let weakSelf = self {
                weakSelf.self.controller?.dismiss(animated: true) {
                    Log.echo(key: "yud", text: "The session is \(session)")
                    
                    //weakSelf.self.controller?.delegate?.loginViewController(viewController: weakSelf, didAuthWith: session)
                }
            }
        }
    }
    
}

extension MemoriesCell{
    
    @objc func checkforSave(){
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.controller?.present(ac, animated: true)
            
        } else {
            
            let ac = UIAlertController(title: "Chatalyze", message: "Your memory has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.controller?.present(ac, animated: true)
        }
    }
    func saveImage(){
        
        if let image = self.memoryImage?.image{
            
            UIImageWriteToSavedPhotosAlbum((image), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
}
