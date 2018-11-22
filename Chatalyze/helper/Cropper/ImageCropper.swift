//
//  ImageCropper.swift
//  Chatalyze
//
//  Created by Mansa on 01/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import CropViewController

class ImageCropper:NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate{
        
    private var imagePicker = UIImagePickerController()
    private var controller:UIViewController?
    var getCroppedImage:((UIImage)->())?
    var isOnlySquare = false
    
    override init() {
        super.init()
        
        initializeVariable()
    }
    
    private func  initializeVariable(){

        imagePicker.delegate = self
    }
    
    func show(controller:UIViewController?){
       
        self.controller = controller
        guard let currentController = self.controller else {
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor.white
       
//        RootControllerManager().getCurrentController()?.present(imagePicker, animated: true, completion: {
//        })
        currentController.present(imagePicker, animated: true, completion: {
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        Log.echo(key: "yud", text: "I am calling selected image is")
        DispatchQueue.main.async {
            
            if let  chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]
                as? UIImage {
                
                Log.echo(key: "yud", text: "selected image is")
                let cropViewController = CropViewController(image: chosenImage)
                if self.isOnlySquare{
                    
                    cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.presetSquare
                    cropViewController.aspectRatioLockEnabled = true
                    cropViewController.aspectRatioPickerButtonHidden = true
                }
                cropViewController.delegate = self
                cropViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.controller?.dismiss(animated: true, completion: {
                    self.controller?.present(cropViewController, animated: true, completion: nil)
                })
            }
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        if let selecetdImage = getCroppedImage{
            selecetdImage(image)
        }
        self.controller?.dismiss(animated: true, completion: {
        })
        Log.echo(key: "yud", text: "Cropped image is \(image)")
        // 'image' is the newly cropped version of the original image
    }
    
     func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        
        self.controller?.dismiss(animated: true, completion: {
        })
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        Log.echo(key: "yud", text: "Controller is dismissing")
        self.controller?.dismiss(animated: true, completion: {
        })
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
