//
//  AchievmentsController.swift
//  Chatalyze
//
//  Created by mansa infotech on 18/04/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//

import UIKit

class AchievmentsController: InterfaceExtendedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paintInterface()
        self.fetchInfo()
    }
    
    var chekpointsArray:[Bool] = [false,false,false,false,false,false,false,false,false,false]
    
    @IBAction func backAction(sender:UIButton?){        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchInfo(){
        
        self.showLoader()
        FetchAchievementsProcessor().fetch { (success, error, response) in
            self.stopLoader()
            
            if !success{
                return
            }
            
            guard let infoArray = response?.array else{
                return
            }
            
            for info in infoArray {
                
                Log.echo(key: "yud", text: "achieved string is \(info["achievement"].stringValue)")

                
//                if info["achievement"].stringValue == "BOOKED_FIRST_CHAT"{
//                    self.chekpointsArray[0] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "RECIEVED_FIRST_MEMORY"{
//                    self.chekpointsArray[1] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "TWO_CHAT_WITH_SAME_HOST"{
//                    self.chekpointsArray[4] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "BOOKED_FIVE_CHATS"{
//                    self.chekpointsArray[5] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "THIRD_POST_CHAT_DONATION"{
//                    self.chekpointsArray[7] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "BOOKED_TEN_CHATS"{
//                    self.chekpointsArray[8] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "BOOKED_TWENTY_CHATS"{
//                    self.chekpointsArray[9] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "SPONSORED_THREE_SESSIONS"{
//                    self.chekpointsArray[6] = true
//                    continue
//                }
//                if info["achievement"].stringValue == "BOOKED_FIRST_CHAT"{
//                    continue
//                }
//                if info["achievement"].stringValue == "BOOKED_FIRST_CHAT"{
//                    continue
//                }
            }
        }
    }
    
    
    func paintInterface(){
        
        self.hideNavigationBar()
        self.paintHideBackButton()
    }
    
    /*
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func instance()->AchievmentsController?{
        
        let storyboard = UIStoryboard(name: "Achievements", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Achievments") as? AchievmentsController
        return controller
    }
    
}
