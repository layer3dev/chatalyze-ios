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
      
      if !(info.isTermsAccepted ?? false) {
        showTermsAndCondtionsPageForOrganizationHost()
      }

        profilePic?.sd_setImage(with: URL(string: info.profileImage ?? ""), placeholderImage: UIImage(named: "orangePup"), options: .highPriority, completed: { (image, error, cache, url) in
            if error == nil {
                self.profilePic?.image = image
            }else{
                self.profilePic?.image = UIImage(named: "orangePup")
            }
        })
    }
  
  
  private func showTermsAndCondtionsPageForOrganizationHost(){
    guard let info = SignedUserInfo.sharedInstance else{
        return
    }
    
    guard let isTermsAceepted = info.isTermsAccepted else {
         return
       }
    
    guard let organizationId = info.organizationId else {return}
    
    if organizationId == ""{
      return
    }
   
    
    if isTermsAceepted{
      print("Terms and Condtion are already accepted for organization Id\(organizationId)")
      return
    }else{
      print("Terms and Condtion not acceptedfor organization Id\(organizationId)")
    }
    
    let vc = HostTermsAndContions()
    vc.modalPresentationStyle = .fullScreen
    let topVC = UIApplication.shared.keyWindow?.rootViewController
    topVC?.present(vc, animated: true, completion: nil)
  }
  
//  func isTermsAccpted()->Bool{
//
//    guard let info = SignedUserInfo.sharedInstance else{
//        return false
//    }
//
//    if info.isTermsAccepted ?? false{
//      return true
//    }else{
//      return false
//    }
//
//}
}
