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
    
    var isInternational : Bool?
        
    override func viewDidLayout() {
        super.viewDidLayout()
        
        setDate()
    }
    
    private func setDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        if let isInternational = isInternational {
            dateFormatter.dateFormat = isInternational ? "dd MMM, yyyy" : "MMM dd, yyyy"
        } else {
            dateFormatter.dateFormat = "dd MMM, yyyy"
        }
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        let selfieDate = Date()
        let requireDate = dateFormatter.string(from: selfieDate)
        dateLabel?.text = " \(requireDate)  "
    }
    
    func renderImage(image : UIImage?){
        
        Log.echo(key: "MemoryStickerView", text: "render Image -> image -> \(image)")
        if(image == nil){
            Log.echo(key: "MemoryStickerView", text: "render Image -> image is nil set height to nil")
            if(logoHeightConstraint == nil){
                Log.echo(key: "MemoryStickerView", text: "render Image -> logoHeightConstraint is nil")
            }
            else{
                Log.echo(key: "MemoryStickerView", text: "render Image -> logoHeightConstraint is NOT nil")
            }
            logoHeightConstraint?.constant = 0
            return
        }
        
        Log.echo(key: "MemoryStickerView", text: "render Image -> image is NOT nil, set height to 35")
        logoHeightConstraint?.constant = 50
        logo?.image = image
    }
}
