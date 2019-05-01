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
    @IBOutlet var testTextView:UITextView?
    
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
    var isOnlySystemTestForTicket = false
    var onlySystemTest = false
    @IBOutlet var soundMeterView:UIView?
    @IBOutlet var statusLbl:UILabel?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        self.checkForMicrphone()
        checkForCameraAccess()
        borderSoundMeter()
        paintStatusMessage()
        setUpGestureOnLabel()
        initializeLink()
        return
    }
    
    
    func borderSoundMeter(){
        
        soundMeterView?.layer.cornerRadius = 3
        soundMeterView?.layer.masksToBounds = true
        soundMeterView?.layer.borderWidth = 2
        soundMeterView?.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
    }
    
    
    func paintStatusMessage(){
        
        //If the answer to both questions is "Yes", your phone passes the test. If not, please check our FAQs or contact us for support.
        
        var fontSize = 18
        var linkSize = 22
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            fontSize = 24
            linkSize = 24
        }
        
        let firstStr = "If the answer to both questions is "
        let mutatedStr = firstStr.toMutableAttributedString(font: AppThemeConfig.defaultFont , size: fontSize , color:UIColor(hexString: "#999999"))
        
        let secondStr = "\("Yes"), "
        let secondAttributedStr = secondStr.toAttributedString(font: AppThemeConfig.boldFont, size: fontSize , color:UIColor(hexString: "#999999"))
        
        let thirdStr = "your phone passes the test. If not, please check our "
        let thirdAttributedStr = thirdStr.toAttributedString(font: AppThemeConfig.defaultFont, size: fontSize , color:UIColor(hexString: "#999999"))
        
        let forthStr = "Help Center"
        let fourthAttributesStr = forthStr.toAttributedStringLink(font: "Nunito-Regular" , size: linkSize , color:UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:true)
        
        let fifthStr = " or "
        let fifthAttributesStr = fifthStr.toAttributedString(font: AppThemeConfig.defaultFont , size: fontSize , color:UIColor(hexString: "#999999"))
        
        let sixthStr = "contact us"
        let sixthAttributesStr = sixthStr.toAttributedStringLink(font: "Nunito-Regular" , size: linkSize , color:UIColor(hexString: AppThemeConfig.themeColor),isUnderLine:true)
        
        let seventhStr = " for support."
        let seventhAttributesStr = seventhStr.toAttributedString(font: AppThemeConfig.defaultFont , size: fontSize , color:UIColor(hexString: "#999999"))
        
        mutatedStr.append(secondAttributedStr)
        mutatedStr.append(thirdAttributedStr)
        mutatedStr.append(fourthAttributesStr)
        mutatedStr.append(fifthAttributesStr)
        mutatedStr.append(sixthAttributesStr)
        mutatedStr.append(seventhAttributesStr)
        
        DispatchQueue.main.async {
            self.statusLbl?.attributedText = mutatedStr
            self.testTextView?.attributedText = mutatedStr
            
        }
        
        //Log.echo(key: "yud", text: "Mutated String is \(mutatedStr)")
    }
    
    
    func setUpGestureOnLabel(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tap:)))
        self.statusLbl?.addGestureRecognizer(tap)
        self.statusLbl?.isUserInteractionEnabled = true
    }
    
    @objc func tapLabel(tap: UITapGestureRecognizer) {
        
        //Log.echo(key: "yud", text: "Tap range is \(self.statusLbl?.text)")
        
        if let msglabel = self.statusLbl{
            
            if let range = msglabel.text?.range(of: "tact us for support.")?.nsRange {
                
                if tap.didTapAttributedTextInLabel(label: msglabel, inRange: range) {
                    
                    Log.echo(key: "yud",text: "Sub string is tapped contact is ")
                    
//                    DispatchQueue.main.async {
//
//                        self.dismiss(animated: true) {
//
//                            guard let rootController = RootControllerManager().getCurrentController() else{
//                                return
//                            }
//
//                            guard let roleId = SignedUserInfo.sharedInstance?.role else{
//                                return
//                            }
//
//                            if roleId  == .analyst{
//                                 rootController.tapAction(menuType: MenuRootView.MenuType.contactUsAnalyst)
//
//                                rootController.closeToggle()
//                                return
//                            }
//
//                            if roleId == .user{
//
//                                rootController.tapAction(menuType: MenuRootView.MenuType.contactUsUser)
//                                rootController.closeToggle()
//                                return
//                            }
//                        }
//                    }
                    return
                }
            }
            
            if let rangeFAQ = msglabel.text?.range(of: "check our FAQs or con")?.nsRange  {
                
                if tap.didTapAttributedTextInLabel(label: msglabel, inRange: rangeFAQ) {
                
                    Log.echo(key: "yud",text: "Sub string is tapped faq is ()")
                    
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: {
//                            guard let rootController = RootControllerManager().getCurrentController() else{
//                                return
//                            }
//                            rootController.showFAQController()
//                        })
//                    }
                    return
                }
            }
        }
    }
    
    
    @objc func appBecomeActiveAgain() {
        
        if self.viewIfLoaded?.window != nil {
            self.checkForMicrphone()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActiveAgain), name: UIApplication.didBecomeActiveNotification, object: nil)
            CameraTestController.levelTimer.invalidate()
            self.checkForMicrphone()
        }
    }
    
    @objc func levelTimerCallback() {
        
        self.recorder?.updateMeters()
        let peakPower = self.recorder?.peakPower(forChannel: 0)
        let level = self.recorder?.averagePower(forChannel: 0)
        //Log.echo(key: "yud", text: "LEVEL IS \(level) and the peak power is \(peakPower)")
        DispatchQueue.main.async {         
            self.updateUI(level:Double(level ?? 0.0))
        }
        let isLoud = level ?? 0.0 > self.LEVEL_THRESHOLD
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Log.echo(key: "yud", text: "I am dissapearing")
        
        DispatchQueue.main.async {
            CameraTestController.levelTimer.invalidate()
        }
    }
    
    func updateUI(level:Double){
        
        if level <= 0{
            
            //Earlier 45 was 40
            //Earlier 20 was 40
            
            //            let newPower = (Float(level) - (LEVEL_THRESHOLD))
            //            let percentage = ((newPower/160))
            //            progressView?.progress = Float(percentage)
            //            let numberOfViewToShown = Int(((percentage*100))*(20/100))
            
            if level < -(50.0){
                self.resetSoundMeter()
                return
            }
            
            let newPowerOne = 50.0+level
            let percentageOne = ((newPowerOne/50))
            progressView?.progress = Float(percentageOne)
            let numberOfViewToShownOne = Int(((percentageOne*100))*(20/100))
            
            //Log.echo(key: "yud", text: "new power is \(newPowerOne) and the number of the view to shown is \(numberOfViewToShownOne) and the percentage is \(percentageOne)")
            
            DispatchQueue.main.async {
                
                self.resetSoundMeter()
                
                if numberOfViewToShownOne < 0{
                    return
                }
                
                for i in 1..<(numberOfViewToShownOne+1){
                    
                    let soundButton = self.view.viewWithTag(i) as? UIButton
                    soundButton?.backgroundColor = UIColor(hexString: AppThemeConfig.themeColor)
                }
            }
        }
    }
    
    func resetSoundMeter(){
        
        for i in 1..<21{
            
            let soundButton = self.view.viewWithTag(i) as? UIButton
            soundButton?.backgroundColor = UIColor.white
        }
    }
    
    func checkForMicrphone(){
        
        CameraTestController.levelTimer.invalidate()
        // Log.echo(key: "yud", text: "Checking for the microphone access")
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
            try
                audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            //                audioSession.setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord), mode: .continuous)
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
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
            checkForMicrphone()
            return
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
            alertToProvideMicrophoneAccess()
            return
        case AVAudioSession.RecordPermission.undetermined:
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
        
        let alert = UIAlertController(title: "Chatalyze", message: "Oops some unexpected error in the camera!!", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
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
        
        let alert = UIAlertController(title: "Chatalyze", message: error?.localizedDescription ?? "Oops some unexpected error during streaming!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
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
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide camera access to chatalyze from the settings", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
            //            self.rootController?.dismiss(animated: true, completion: {
            //                if let listener = self.dismissListner{
            //                    listener()
            //                }
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                
                UIApplication.shared.openURL(settingUrl)
            }
            exit(0)
            //            })
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: false) {
        }
    }
    
    @IBAction func procceds(sender:UIButton){
        
        self.dismiss(animated: false, completion: {
            
            if self.onlySystemTest{
                return
            }
            
            if self.isOnlySystemTestForTicket{
                
                guard let controller = FreeEventPaymentController.instance() else{
                    return
                }
                controller.info = self.info                
                DispatchQueue.main.async {
                    RootControllerManager().getCurrentController()?.present(controller, animated: false, completion: {
                    })
                }
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
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide microphone access to chatalyze from the settings", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: { (action) in
            //            self.rootController?.dismiss(animated: true, completion: {
            if let settingUrl = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.openURL(settingUrl)
            }
            exit(0)
            //            })
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: false) {
        }
    }
}

extension CameraTestController {
    
    class func instance()->CameraTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CameraTest") as? CameraTestController
        return controller
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}


extension CameraTestController:UITextViewDelegate {
    
    func initializeLink(){
     
        testTextView?.delegate = self
        testTextView?.isSelectable = true
        testTextView?.isEditable = false
        testTextView?.dataDetectorTypes = .link
        testTextView?.isUserInteractionEnabled = true
        testTextView?.linkTextAttributes = [NSAttributedString.Key.font:UIColor(hexString:AppThemeConfig.themeColor)]
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range == textView.text?.range(of: "contact us for support.")?.nsRange {
            Log.echo(key: "yud", text: "contact us is called")
        }
        
        if  range == textView.text?.range(of: "our FAQs")?.nsRange {
            Log.echo(key: "yud", text: "FAQ is called")
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        Log.echo(key: "yud", text: "interacting with url")
       
        if characterRange == testTextView?.text?.range(of: "if the answer to both")?.nsRange {
            
            Log.echo(key: "yud", text: "interacting with if the answer to both")
        }
        
        
        if characterRange == testTextView?.text?.range(of: "contact us")?.nsRange {
            
            DispatchQueue.main.async {
                
                self.dismiss(animated: true) {
                    
                    guard let rootController = RootControllerManager().getCurrentController() else{
                        return
                    }
                    
                    guard let roleId = SignedUserInfo.sharedInstance?.role else{
                        return
                    }
                    
                    if roleId  == .analyst{
                        rootController.tapAction(menuType: MenuRootView.MenuType.contactUsAnalyst)
                        
                        rootController.closeToggle()
                        return
                    }
                    
                    if roleId == .user{
                        
                        rootController.tapAction(menuType: MenuRootView.MenuType.contactUsUser)
                        rootController.closeToggle()
                        return
                    }
                }
            }
            return false
            Log.echo(key: "yud", text: "contact us is called")
        }
        
        if  characterRange == testTextView?.text?.range(of: "Help Center")?.nsRange {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    guard let rootController = RootControllerManager().getCurrentController() else{
                        return
                    }
                    rootController.showFAQController()
                })
            }
            return false
            Log.echo(key: "yud", text: "FAQ is called")
        }
        return false
    }
}
