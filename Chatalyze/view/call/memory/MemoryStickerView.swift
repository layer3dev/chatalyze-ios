//
//  MemoryStickerView.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 23/05/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation

class MemoryStickerView : ExtendedView{
    
    @IBOutlet private var logo : UIImageView?
    @IBOutlet private var dateLabel : UILabel?
    
    @IBOutlet private var logoHeightConstraint : NSLayoutConstraint?
    
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        setDate()
    }
    
    private func setDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let selfieDate = Date()
        let requireDate = dateFormatter.string(from: selfieDate)
        dateLabel?.text = "\(requireDate)"
    }
    
    func renderImage(image : UIImage?){
        if(image == nil){
            
            logoHeightConstraint?.constant = 0
            return
        }
        logoHeightConstraint?.constant = 35
        logo?.image = image
    }
}
