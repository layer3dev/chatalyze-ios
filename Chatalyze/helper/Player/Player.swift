//
//  Player.swift
//  Geo app
//
//  Created by Mansa Mac-3 on 5/5/20.
//  Copyright © 2020 Mans MAC 3. All rights reserved.
//

import Foundation
import AVFoundation

class Player : NSObject{
    
    var audioFile: AVAudioPlayer!
    var audioEnded:(()->())?
    
    override init() {
        super.init()
        
        let soundURL = Bundle.main.url(forResource: "testMusic", withExtension: "mp3")

        do {
            try audioFile = AVAudioPlayer(contentsOf: soundURL!)
        } catch {
            print(error)
        }
    }
    
    func initialize(_ completion:@escaping ()->()){
        
        self.audioFile.delegate = self
        self.audioEnded = completion
    }
    
    // Methods
    func playAudioFile() {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            //try session.setCategory(AVAudioSession.Category.playback)
            try session.setCategory(AVAudioSession.Category.playback, options: [AVAudioSession.CategoryOptions.allowAirPlay,AVAudioSession.CategoryOptions.allowBluetooth,AVAudioSession.CategoryOptions.allowBluetoothA2DP])
        }
        catch{
        }
        
        audioFile.play()
    }
    
    func stopAudioFile() {
        audioFile.stop()
    }
}



extension Player: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioEnded?()
    }
}
