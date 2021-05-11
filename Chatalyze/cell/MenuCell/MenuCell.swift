//
//  MenuCell.swift
//  Chatalyze
//
//  Created by Mansa on 21/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class MenuCell: ExtendedTableCell {
    
    @IBOutlet var userImage:UIImageView?
    var info:MenuInfo?
    @IBOutlet var optionName:UILabel?
    var selectedSlideBarTab:((MenuRootView.MenuType?)->())?
        
    override func viewDidLayout() {
        super.viewDidLayout()
        
        painInterface()
    }
    
    func painInterface(){
        
        self.selectionStyle = .none
    }
    
    func fillInfo(info:MenuInfo?){
        
        guard let info = info else{
            return
        }
        self.info = info
        userImage?.image = UIImage(named: "base")
        
//        if let imageStr = info.screenShotUrl{
//            if let url = URL(string: imageStr){
//                memoryImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "base"), options: SDWebImageOptions.highPriority, completed: { (image, error, cache, url) in
//                })
//            }
//        }
    }
    
    @IBAction func tabAction(sender:UIButton){
        
        Log.echo(key: "yud", text: "Action is calling")
        if let sideTabAction = self.selectedSlideBarTab{
            sideTabAction(getSelectedTab())
        }
    }
    
    func getSelectedTab()->MenuRootView.MenuType{
        
        guard let selectedIndexName = self.optionName?.text else{
            return MenuRootView.MenuType.none
        }
        
        if let role = SignedUserInfo.sharedInstance?.role{
            if role == .analyst  {
                
                if selectedIndexName == "My sessions"{
                    return MenuRootView.MenuType.mySessionAnalyst
                }
                else if selectedIndexName == "Payment dashboard"{
                    return MenuRootView.MenuType.paymentAnalyst
                }
                else if selectedIndexName == "Schedule Session"{
                    return MenuRootView.MenuType.scheduledSessionAnalyst
                }
                else if selectedIndexName == "Edit Profile"{
                    return MenuRootView.MenuType.editProfileAnalyst
                }
                else if selectedIndexName == "Get in touch"{
                    return MenuRootView.MenuType.contactUsAnalyst
                }
                else if selectedIndexName == "Support"{
                    return MenuRootView.MenuType.contactUsAnalyst
                }
                else if selectedIndexName == "Settings"{
                    return MenuRootView.MenuType.settings
                }
                else if selectedIndexName == "Chatalyze Pro"{
                    return MenuRootView.MenuType.proFeature
                }
                else if selectedIndexName == "Refer friends and earn"{
                    return MenuRootView.MenuType.referAndEarn
                }                
                return MenuRootView.MenuType.none
            }
            
            if selectedIndexName == "Contact Us"{
                return MenuRootView.MenuType.contactUsUser
            }
            else if selectedIndexName == "Edit Profile"{
                return MenuRootView.MenuType.editProfileUser
            }
            else if selectedIndexName == "Payment History"{
                return MenuRootView.MenuType.paymentUser
            }
            else if selectedIndexName == "Memories"{
                return MenuRootView.MenuType.autograph
            }
            else if selectedIndexName == "My Tickets"{
                return MenuRootView.MenuType.tickets
            }
            else if selectedIndexName == "Purchase"{
                return MenuRootView.MenuType.events
            }
            else if selectedIndexName == "Settings"{
                return MenuRootView.MenuType.settings
            }
            else if selectedIndexName == "Achievements"{
                return MenuRootView.MenuType.achievements
            }else if selectedIndexName ==  "Change Language"{
                return MenuRootView.MenuType.changeLanguage
            }
            
            return MenuRootView.MenuType.none
        }
        return MenuRootView.MenuType.none

        
//        var analystArray = ["My Sessions","Payout details","Get in touch","Settings","Refer friends and earn"]
//        var userArray = ["My Tickets","Memories","Purchase","History", "Settings"]
    
    }
}

