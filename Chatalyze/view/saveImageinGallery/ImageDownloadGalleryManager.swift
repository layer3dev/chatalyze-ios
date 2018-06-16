//
//  ImageDownloadGalleryManager.swift
//  Chatalyze
//
//  Created by Mansa on 16/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation
class ImageDownloadGalleryManager{
    
    fileprivate var id : String
    
    init(id:String) {
        self.id = id
    }
    
    func getSaveDirectory()->String?{
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        path = path + "/" + "galleryImage"
        Log.echo(key: "yud", text: "getSaveDirectory is \(path)")
        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: path)){
            
            Log.echo(key: "yud", text: "File Exists is  \(path)")
            return path
        }
        do{
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            Log.echo(key: "yud", text: "File Created Successfully   \(path)")
        }catch{
            Log.echo(key: "yud", text: "Directory could not be created  \(path)")
            return nil
        }
        return path
    }
    
    func getSavePathForImage()->String?{
        
        guard let dir = getSaveDirectory()
            else{
                return nil
        }
        let path = dir  + "/" + self.id + ".jpg"
        //let path = dir  + "/"  + self.callBookingId + ".jpg"
        Log.echo(key: "yud", text: "getSavePathForDefaultImage is  \(path)")
        return path
    }
    
}
