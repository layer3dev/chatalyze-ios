//
//  CameraTestController.swift
//  Chatalyze
//
//  Created by Mansa on 07/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import AVFoundation

class CameraTestController: InterfaceExtendedController {
    
    @IBOutlet weak var cameraPreview: UIView?
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var rootController:SystemTestController?
    var front = true
    override func viewDidLayout() {
        super.viewDidLayout()
        
        checkForCameraAccess()
        return
    }
    
    func errorInCamera(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Oops some unexpected error in the camera!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.rootController?.dismiss(animated: true, completion: {
            })
        }))
        self.present(alert, animated: true) {
        }
    }
    func errorInCapturing(error:Error?){
        
        let alert = UIAlertController(title: "Chatalyze", message: error?.localizedDescription ?? "Oops some unexpected error during streaming!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.rootController?.dismiss(animated: true, completion: {
            })
        }))
        self.present(alert, animated: true) {
        }
    }
    
    func startCameraTestFront(){
        
        session = AVCaptureSession()
        output = AVCaptureStillImageOutput()
        guard let camera = getDevice(position: .front) else {
            errorInCamera()
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError {
            errorInCapturing(error:error)
            print(error)
            input = nil
        }
        guard let inputStream =  input else {
            return
        }
        guard let outPutStream =  output else {
            return
        }
        guard let sessionStream =  session else {
            return
        }
        if(session?.canAddInput(inputStream) == true){
            session?.addInput(inputStream)
            output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            if(session?.canAddOutput(outPutStream) == true){
                session?.addOutput(outPutStream)
                previewLayer = AVCaptureVideoPreviewLayer(session: sessionStream)
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewLayer?.frame = (cameraPreview?.bounds) ?? CGRect()
                if let previewLr = previewLayer{
                    cameraPreview?.layer.addSublayer(previewLr)
                    session?.startRunning()
                }else{
                    self.rootController?.dismiss(animated: true, completion: {
                    })
                }
            }
        }
    }
    
    func startCameraTestBack(){
        
        session = AVCaptureSession()
        output = AVCaptureStillImageOutput()
        guard let camera = getDevice(position: .back) else {
            errorInCamera()
            return
        }
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError {
            errorInCapturing(error:error)
            print(error)
            input = nil
        }
        guard let inputStream =  input else {
            return
        }
        guard let outPutStream =  output else {
            return
        }
        guard let sessionStream =  session else {
            return
        }
        if(session?.canAddInput(inputStream) == true){
            session?.addInput(inputStream)
            output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            if(session?.canAddOutput(outPutStream) == true){
                session?.addOutput(outPutStream)
                previewLayer = AVCaptureVideoPreviewLayer(session: sessionStream)
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewLayer?.frame = (cameraPreview?.bounds) ?? CGRect()
                if let previewLr = previewLayer{
                    cameraPreview?.layer.addSublayer(previewLr)
                    session?.startRunning()
                }else{
                    self.rootController?.dismiss(animated: true, completion: {
                    })
                }
            }
        }
    }
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
                
        let devices: NSArray = AVCaptureDevice.devices() as NSArray
        for de in devices {
            let deviceConverted = de as? AVCaptureDevice
            if((deviceConverted as AnyObject).position == position){
                return deviceConverted
            }
        }
        return nil
    }
    func switchDevice() {
       
        if front == true{
        
            front = false
            session?.stopRunning()
            startCameraTestBack()
            return
        }

        front = true
        session?.stopRunning()
        startCameraTestFront()
        return
    }
    
    func checkForCameraAccess(){
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied:
            Log.echo(key: "yud", text: "Your Authorisation is denied")
            alertToProvideCameraAccess()
            break
        case .authorized:
            
            startCameraTestFront()
            Log.echo(key: "yud", text: "Your Authorisation is authorized")
            break
        case .restricted:
            Log.echo(key: "yud", text: "Your Authorisation is restricted")
            alertToProvideCameraAccess()
            break
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    self.startCameraTestFront()
                    print("Granted access to \(cameraMediaType)")
                } else {
                    self.alertToProvideCameraAccess()
                    print("Denied access to \(cameraMediaType)")
                }
            }
            break
        }
    }
    
    
    func alertToProvideCameraAccess(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide camera access to chatalyze from the settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.rootController?.dismiss(animated: true, completion: {
            })
        }))
        self.present(alert, animated: true) {
        }
    }
    
    @IBAction func dismissAction(){
        
        self.rootController?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func frontCamera(){
        
       switchDevice()
    }
    @IBAction func backCamera(){
        
        switchDevice()
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


extension CameraTestController{
    
    class func instance()->CameraTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CameraTest") as? CameraTestController
        return controller
    }
}
