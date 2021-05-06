//
//  LocalizedLabel.swift
//  Chatalyze
//
//  Created by Abhishek Dhiman on 06/05/21.
//  Copyright © 2021 Mansa Infotech. All rights reserved.
//

import UIKit

@IBDesignable
class LocalizedLabel: UILabel {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: AppNotification.changeLanguage, object: nil)
    }

    @IBInspectable var localizeLanguage : String?{
        didSet{
            updateUI()
        }
    }
    
    @objc private func updateUI(){
        if let string = localizeLanguage{
            text = string.localized()
        }
    }

}
