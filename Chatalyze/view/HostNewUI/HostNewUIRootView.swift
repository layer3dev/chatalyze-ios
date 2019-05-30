//
//  HostNewUIRootView.swift
//  Chatalyze
//
//  Created by mansa infotech on 30/05/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit
import SDWebImage

class HostNewUIRootView: ExtendedRootView {

    @IBOutlet var userName:UILabel?
    @IBOutlet var userDetail:UILabel?
    @IBOutlet var profilePic:UIImageView?
    
    func paintInterface(){
        
        guard let info = SignedUserInfo.sharedInstance else{
            return
        }
        
        self.userName?.text = info.fullName
        self.userDetail?.text = info.userDescription

        profilePic?.sd_setImage(with: URL(string: info.profileImage ?? ""), placeholderImage: UIImage(named: "orangePup"), options: .highPriority, completed: { (image, error, cache, url) in
            if error == nil {
                self.profilePic?.image = image
            }else{
                self.profilePic?.image = UIImage(named: "orangePup")
            }
        })
    }
}
