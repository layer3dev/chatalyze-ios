//
//  Utils.swift
//  ImageLoaderExample
//
//  Created by Hirohisa Kawasaki on 12/18/14.
//  Copyright (c) 2014 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

extension String {

    static func imageURL(_ index: Int) -> String {

        var number = index.description
        while (number.characters.count < 3) {
            number = "0\(number)"
        }
        return "https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage\(number).jpg"
    }

}

extension URL {

    static func imageURL(_ index: Int) -> URL {

        var number = index.description
        while (number.characters.count < 3) {
            number = "0\(number)"
        }
        let string = "https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage\(number).jpg"

        return URL(string: string)!
    }

}

extension UIImage {
    public convenience init?(color: UIColor) {
        self.init(color: color, size: CGSize(width: 1, height: 1))
    }

    public convenience init?(color: UIColor, size: CGSize) {
        let frameFor1px = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(frameFor1px.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(frameFor1px)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image!.cgImage else { return nil }

        self.init(cgImage: cgImage)
    }
}
