
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
//import FBSDKShareKit
//import FacebookShare


class MemoriesCell: ExtendedTableCell {
    
    @IBOutlet var orderIdLbl:UILabel?
    @IBOutlet var dateLbl:UILabel?
    @IBOutlet var amountLbl:UILabel?
    @IBOutlet var orderType:UILabel?
    @IBOutlet var cardView:UIView?
    @IBOutlet var memoryImage:UIImageView?
    var controller:MemoriesController?
    var info:MemoriesInfo?
    var deletingCellInfo:((IndexPath?)->())?
    var indexPath:IndexPath?
    var beginsUpdate:(()->())?
    var endsUpdate:(()->())?
    
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
        
        guard let memoryImage = self.memoryImage?.image else{
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            avc.popoverPresentationController?.sourceView = self
            avc.popoverPresentationController?.sourceRect = sender.frame
            self.controller?.present(avc, animated: true, completion: nil)
            
        }else{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            self.controller?.present(avc, animated: true, completion: nil)
        }        
    }
    
    @IBAction func facebookShare(sender:UIButton){        
        
        guard let id = self.info?.id else{
            return
        }
        
//        var url = "https://chatalyze.com/api/screenshots/"
//        url = url+id
//        url = url+"/url/chatalyze.png"
//        
//        Log.echo(key: "yud", text: "Image url is \(url)")
//        
//        do{
//            guard let image1 = self.memoryImage?.image else{
//                return
//            }
//            let photo = Photo(image: image1, userGenerated: true)
//            var contentImage = PhotoShareContent(photos: [photo])
//            contentImage.url = URL(string: url)
//            do{
//                guard let controller = self.controller else {
//                    return
//                }
//                try ShareDialog.show(from: controller, content: contentImage) { (result) in
//                }
//            }catch{
//                
//                let alert = UIAlertController(title: AppInfoConfig.appName, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
//                }))
//                
//                self.controller?.present(alert, animated: true, completion: {
//                })
//            }
//        }catch{
//            print("Unable to load data: \(error)")
//        }
    }
    
    @IBAction func saveImageInGallery(sender:UIButton){
        
        self.saveImage()
    }
}

extension MemoriesCell{
    
    @IBAction func showImage(sender:UIButton){
        
        guard let controller = PageScrollerController.instance() else{
            return
        }
        controller.showingImage = self.memoryImage?.image
        controller.info = self.info
        controller.deleteCell = {
            if let deletedCell = self.deletingCellInfo{
                deletedCell(self.indexPath)
            }
        }
        self.controller?.present(controller, animated: true)
    }
    
    
    @objc func checkforSave(){
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            
            //We got back an error!
            let ac = UIAlertController(title: AppInfoConfig.appName, message: "Please provide the access to save the photos in the Gallery.", preferredStyle: .alert)
          
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert) in
                
                if let settingUrl = URL(string:UIApplication.openSettingsURLString){
                    if #available(iOS 10.0, *) {
                        
                        UIApplication.shared.open(settingUrl)
                    } else {
                        //Fallback on earlier versions
                        UIApplication.shared.openURL(settingUrl)
                    }
                }
            }))
            self.controller?.present(ac, animated: true)
            
        } else {
            
            let ac = UIAlertController(title: AppInfoConfig.appName, message: "Your memory has been saved to your photos.", preferredStyle: .alert)
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
