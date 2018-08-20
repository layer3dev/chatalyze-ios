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
    
    @IBOutlet var progressView:UIProgressView?
    var recorder: AVAudioRecorder?
    private static var levelTimer = Timer()
    var dismissListner:(()->())?
    
    let LEVEL_THRESHOLD: Float = -160.0
    var powerLevelIndicator = -200.0
    //Above for mic
    
    @IBOutlet weak var cameraPreview: UIView?
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var rootController:InternetSpeedTestController?
    var front = true
    var onSuccessTest:((Bool)->())?
    var info:EventInfo?
    var isOnlySystemTest = false
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.checkForMicrphone()
        checkForCameraAccess()
        return
    }
    
    @objc func appBecomeActiveAgain() {
        
        if self.viewIfLoaded?.window != nil {
            self.checkForMicrphone()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActiveAgain), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            CameraTestController.levelTimer.invalidate()
            self.checkForMicrphone()
        }
    }
    
    @objc func levelTimerCallback() {
        
        self.recorder?.updateMeters()
        let peakPower = self.recorder?.peakPower(forChannel: 0)
        let level = self.recorder?.averagePower(forChannel: 0)
        Log.echo(key: "yud", text: "LEVEL IS \(level)")
        self.updateUI(level:Double(level ?? 0.0))
        let isLoud = level ?? 0.0 > self.LEVEL_THRESHOLD
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Log.echo(key: "yud", text: "I am dissapearing")
        
        DispatchQueue.main.async {
            CameraTestController.levelTimer.invalidate()
        }
    }
    
    func updateUI(level:Double){
        
        if level <= 0{
            
            powerLevelIndicator = level + 40
            let percentage = ((powerLevelIndicator/40))
            progressView?.progress = Float(percentage)
        }
    }
    
    func checkForMicrphone(){
        
        CameraTestController.levelTimer.invalidate()
        Log.echo(key: "yud", text: "Checking for the microphone access")
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
        recorder?.record()
        
        CameraTestController.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    func checkforMicrophoneAccess(){
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
            checkForMicrphone()
            return
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            alertToProvideMicrophoneAccess()
            return
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                
                if !granted{
                    
                    self.alertToProvideMicrophoneAccess()
                    return
                }
                self.checkForMicrphone()
                //Handle granted
            })
        }
    }
    
    
    func errorInCamera(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Oops some unexpected error in the camera!!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: false, completion: {
                if let listner = self.dismissListner{
                    listner()
                }
            })
        }))
        RootControllerManager().getCurrentController()?.present(alert, animated: false) {
        }
    }
    func errorInCapturing(error:Error?){
        
        let alert = UIAlertController(title: "Chatalyze", message: error?.localizedDescription ?? "Oops some unexpected error during streaming!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: false, completion: {
                if let listener = self.dismissListner{
                    listener()
                }
            })
        }))
        self.present(alert, animated: false) {
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
                DispatchQueue.main.async {
                    
                    self.previewLayer?.frame = (self.cameraPreview?.bounds) ?? CGRect()
                    
                    if let previewLr = self.previewLayer{
                        self.cameraPreview?.layer.addSublayer(previewLr)
                        self.session?.startRunning()
                    }else{
                        self.dismiss(animated: false, completion: {
                            if let listener = self.dismissListner{
                                listener()
                            }
                        })
                    }
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
                    self.dismiss(animated: false, completion: {
                        if let listener = self.dismissListner{
                            listener()
                        }
                    })
                }
            }
        }
    }
    
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        
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
            return
        case .authorized:
            
            startCameraTestFront()
            checkforMicrophoneAccess()
            Log.echo(key: "yud", text: "Your Authorisation is authorized")
            return
        case .restricted:            
            Log.echo(key: "yud", text: "Your Authorisation is restricted")
            alertToProvideCameraAccess()
            return
        case .notDetermined:
            
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    
                    self.startCameraTestFront()
                    self.checkforMicrophoneAccess()
                    print("Granted access to \(cameraMediaType)")
                } else {
                    self.alertToProvideCameraAccess()
                    print("Denied access to \(cameraMediaType)")
                }
            }
            return
        }
    }
    
    
    func alertToProvideCameraAccess(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide camera access to chatalyze from the settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            //            self.rootController?.dismiss(animated: true, completion: {
            //                if let listener = self.dismissListner{
            //                    listener()
            //                }
            if let settingUrl = URL(string: UIApplicationOpenSettingsURLString){
                
                UIApplication.shared.openURL(settingUrl)
            }
            exit(0)
            //            })
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: false) {
        }
    }
    
    @IBAction func procceds(sender:UIButton){
        
        self.dismiss(animated: false, completion: {
            
            if self.isOnlySystemTest{
                return
            }
            
            guard let controller = EventPaymentController.instance() else{
                return
            }
            
            controller.info = self.info
         
            //        if self.info?.isFree ?? false{
            //            return
            //        }
            //            controller.dismissListner = {(success) in
            //                self.dismiss(animated: false, completion: {
            //                    DispatchQueue.main.async {
            //                        if let listner = self.dismissListner{
            //                            listner(success)
            //                        }
            //                    }
            //                })
            //            }
            RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
            })
        })
        
    }
    
    @IBAction func dismissAction(){
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                if let handler = self.onSuccessTest{
                    handler(true)
                }
            })
        }
    }
    
    @IBAction func frontCamera(){
        
        switchDevice()
    }
    @IBAction func backCamera(){
        
        // switchDevice()
        
        //        guard let controller = MicTestController.instance() else{
        //            return
        //        }
        //        controller.rootController = self.rootController
        //        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //        self.present(controller, animated: true, completion: {
        //        })
    }
    
    func alertToProvideMicrophoneAccess(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide microphone access to chatalyze from the settings", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            //            self.rootController?.dismiss(animated: true, completion: {
            if let settingUrl = URL(string: UIApplicationOpenSettingsURLString){
                UIApplication.shared.openURL(settingUrl)
            }
            exit(0)
            //            })
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
           
        }))
        
        self.present(alert, animated: false) {
        }
    }
}

extension CameraTestController{
    
    class func instance()->CameraTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CameraTest") as? CameraTestController
        return controller
    }
}
