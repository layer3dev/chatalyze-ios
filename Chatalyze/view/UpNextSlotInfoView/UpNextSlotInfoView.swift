//
//  UpNextSlotInfoView.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 09/04/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import Foundation
import UIKit

class UpNextSlotInfoView: ExtendedView {


    //MARK:- @IBOUTLETS
    
    @IBOutlet var upNextSlotLbl : UILabel?
    @IBOutlet var upNextUserNamelbl : UILabel?
    @IBOutlet var timeleftLbl : UILabel?

    override func viewDidLayout() {
        super.viewDidLayout()

        self.layer.cornerRadius = 6
    }


    func showUpComingSlotInfo(slotNo: String,upComingUser:String,time: String,totalSlots: String){

        self.isHidden = false

        var fontSize = 16
        var nameFontSize = 24
        var timeRemainingFontSize = 38

        if  UIDevice.current.userInterfaceIdiom == .pad{
            fontSize = 20
             nameFontSize = 32
            timeRemainingFontSize = 42

        }

        let currentSlotText = "UP NEXT (\(slotNo) of \(totalSlots))"
        let currentMutatedSlotText = currentSlotText.toMutableAttributedString(font: "Nunito-Regular", size: fontSize, color: UIColor(hexString: "#000000"), isUnderLine: false)
        self.upNextSlotLbl?.attributedText = currentMutatedSlotText



        let slotUserNameAttrStr = upComingUser.toAttributedString(font: "Nunito-ExtraBold", size: nameFontSize, color: UIColor(hexString: "#000000"), isUnderLine: false)
        self.upNextUserNamelbl?.attributedText = slotUserNameAttrStr

        let timeAttributedString = time.toAttributedString(font: "Nunito-ExtraBold", size: timeRemainingFontSize, color: UIColor(hexString: "#FF434E"), isUnderLine: false)
        self.timeleftLbl?.attributedText = timeAttributedString
    }


    func hideUpNextSlotInfo(){

        self.isHidden = true
        self.upNextSlotLbl?.text = ""
        self.upNextUserNamelbl?.text = ""
        self.timeleftLbl?.text = ""

    }


}
