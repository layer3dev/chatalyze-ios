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
                if selectedIndexName == "My Sessions"{
                    return MenuRootView.MenuType.mySessionAnalyst
                }
                else if selectedIndexName == "Payments"{
                    return MenuRootView.MenuType.paymentAnalyst
                }
                else if selectedIndexName == "Schedule Session"{
                    return MenuRootView.MenuType.scheduledSessionAnalyst
                }
                else if selectedIndexName == "Edit Profile"{
                    return MenuRootView.MenuType.editProfileAnalyst
                }
                else if selectedIndexName == "Contact Us"{
                    return MenuRootView.MenuType.contactUsAnalyst
                }
                return MenuRootView.MenuType.none
            }
            
            //Implement For the user            
            if selectedIndexName == "Contact Us"{
                return MenuRootView.MenuType.contactUsUser
            }
            else if selectedIndexName == "Edit Profile"{
                return MenuRootView.MenuType.editProfileUser
            }
            else if selectedIndexName == "Payments"{
                return MenuRootView.MenuType.paymentUser
            }
            else if selectedIndexName == "Autographs"{
                return MenuRootView.MenuType.autograph
            }
            else if selectedIndexName == "My Tickets"{
                return MenuRootView.MenuType.tickets
            }
            return MenuRootView.MenuType.none
        }
        return MenuRootView.MenuType.none

        
//        
//        ["My Sessions","Payments","Schedule Session","Edit Profile","Contact Us"]
//        var userArray = ["Payments","Edit Profile","Contact Us"]
    
    }
}

