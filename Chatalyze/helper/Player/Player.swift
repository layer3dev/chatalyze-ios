//
//  Player.swift
//  Geo app
//
//  Created by Mansa Mac-3 on 5/5/20.
//  Copyright © 2020 Mans MAC 3. All rights reserved.
//

import Foundation
import AVFoundation

class Player {

   
    var audioFile: AVAudioPlayer!

   
  init() {
  
    let soundURL = Bundle.main.url(forResource: "bensound-summer (1) (mp3cut.net)", withExtension: "mp3")
    
    do {
      try audioFile = AVAudioPlayer(contentsOf: soundURL!)
    } catch {
      print(error)
    }
    
    let session = AVAudioSession.sharedInstance()
    
    do {
      try session.setCategory(AVAudioSession.Category.playback)
    }
    catch{
      
    }
  }

    // Methods
    func playAudioFile() {
      audioFile.play()
    }
  
  
  func stopAudioFile() {
    audioFile.stop()
  }
  
}
