//
//  CacheImageLoader.swift
//  BN PERKS
//
//  Created by Sumant Handa on 17/02/18.
//  Copyright © 2018 Mansa. All rights reserved.
//

import Foundation
import SDWebImage

class CacheImageLoader : NSObject{
    
    var cache : [String : UIImage] = [:]
    
    
    override init(){
        super.init()
    }
    
    static let sharedInstance = CacheImageLoader()
    
    func loadImage(_ urlString : String?, token : @escaping ()->(Int) , completionBlock : @escaping (_ success : Bool, _ image : UIImage?)->()){
        
        /*
         SDWebImageManager *manager = [SDWebImageManager sharedManager];
         [manager loadImageWithURL:imageURL
         options:0
         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         // progression tracking code
         }
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         if (image) {
         // do something with image
         }
         }];
         */
        guard let urlString = urlString
            else{
                completionBlock(false, nil)
                return
        }
        let manager = SDWebImageManager.shared()
        guard let url = URL(string: urlString)
            else{
                completionBlock(false, nil)
                return
        }
        
        manager.loadImage(with: url, options: [], progress: { (receivedSize, expectedSize, url) in
            
        }) { (image, data, error, cacheType, finished, url) in
            if(!finished){
                return
            }
            guard let image = image
                else{
                    completionBlock(false, nil)
                    return
            }
            completionBlock(true, image)
            return
            
        }
        
    }
}
