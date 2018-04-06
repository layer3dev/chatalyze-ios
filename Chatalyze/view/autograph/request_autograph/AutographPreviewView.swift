
//
//  AutographPreviewView.swift
//  Chatalyze
//
//  Created by Sumant Handa on 05/04/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class AutographPreviewView: ExtendedView {
    
    @IBOutlet var previewImage : UIImageView?
    @IBOutlet var loader : LoaderView?
    private var screenshotInfo : ScreenshotInfo?
    private var imageLoader = CacheImageLoader.sharedInstance
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    func fillInfo(info : ScreenshotInfo?){
        self.screenshotInfo = info
        loader?.loader?.startAnimating()
        imageLoader.loadImage(screenshotInfo?.screenshot, token: { () -> (Int) in
            return 0
        }) {[weak self] (success, image) in
            self?.loader?.loader?.stopAnimating()
            self?.previewImage?.image = image
        }
    }

}
