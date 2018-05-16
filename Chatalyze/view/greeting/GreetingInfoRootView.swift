//
//  GreetingInfoRootView.swift
//  Chatalyze
//
//  Created by Mansa on 05/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
import SDWebImage

class GreetingInfoRootView:ExtendedView{
    
    @IBOutlet var priceforgreeting:UILabel?
    @IBOutlet var greetingImage:UIImageView?
    var info:GreetingInfo?
    var controller:GreetingInfoController?
    @IBOutlet var aboutusView:GreetingInfoButtonContainer?
    override func viewDidLayout() {
        super.viewDidLayout()
    
        painInterface()
        initializeVariable()
    }
    
    func painInterface(){
              
        aboutusView?.layer.borderWidth = 1
        aboutusView?.layer.borderColor = UIColor(red: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1).cgColor
    }
    func initializeVariable(){
        
        if let price = info?.price{
         
            priceforgreeting?.text = "$"+"\(price)"
        }
        if let imageUrl = info?.greetingImageUrl{
           
            greetingImage?.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named:"base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
                
            })
        }       
    }
    
    @IBAction func personalize(sender:UIButton){
        
        guard let controller = GreetingDateTimeController.instance() else {
            return
        }
        controller.info = self.info
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
