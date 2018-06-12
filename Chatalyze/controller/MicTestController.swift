//
//  MicTestController.swift
//  Chatalyze
//
//  Created by Mansa on 12/06/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio
import Foundation

class MicTestController: InterfaceExtendedController {

    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    let LEVEL_THRESHOLD: Float = -160.0
    var powerLevelIndicator = -200.0
    
    @IBOutlet var progressView:UIProgressView?
    var rootController:SystemTestController?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            print("Permission granted")
            checkForMicrphone()
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
            alertToProvideMicrophoneAccess()
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
    
    func checkForMicrphone(){
      
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
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    
    @objc func levelTimerCallback() {
        
        recorder.updateMeters()
        let peakPower = recorder.peakPower(forChannel: 0)
        let level = recorder.averagePower(forChannel: 0)
        Log.echo(key: "yud", text: "LEVEL IS \(level)")
        updateUI(level:Double(level))
        let isLoud = level > LEVEL_THRESHOLD
    }
    
    
    func updateUI(level:Double){
        
        if level <= 0{

            powerLevelIndicator = level + 40
            let percentage = ((powerLevelIndicator/40))
            progressView?.progress = Float(percentage)
        }
    }
    
    @IBAction func dismissAction(){

        self.rootController?.dismiss(animated: true, completion: {
        })
    }
    
    
    func alertToProvideMicrophoneAccess(){
        
        let alert = UIAlertController(title: "Chatalyze", message: "Please provide microphone access to chatalyze from the settings", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.rootController?.dismiss(animated: true, completion: {
                
                if let settingUrl = URL(string: UIApplicationOpenSettingsURLString){
                    
                    UIApplication.shared.openURL(settingUrl)
                }
            })
        }))
        self.present(alert, animated: true) {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension MicTestController{
    
    class func instance()->MicTestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MicTest") as? MicTestController
        return controller
    }
}
