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

   
    var audioFile: AVAudioPlayer?
  var session = AVAudioSession.sharedInstance()
   
  init() {
    
    
    self.session = AVAudioSession.sharedInstance()
    let currentRoute = self.session.currentRoute
    if currentRoute.outputs.count != 0 {
      for description in currentRoute.outputs {
        if description.portType == AVAudioSession.Port.bluetoothA2DP {
          print("headphone plugged in")
          
          do {
            try session.overrideOutputAudioPort(.none)
          } catch {
            print("errr is \(error.localizedDescription)")
          }
          
          
        } else {
          print("headphone pulled out")
        }
      }
    } else {
      print("requires connection to device")
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(audioRouteChangeListener),
      name: AVAudioSession.routeChangeNotification,
      object: nil)
    
    let soundURL = Bundle.main.url(forResource: "testMusic", withExtension: "mp3")
    
    do {
      try audioFile = AVAudioPlayer(contentsOf: soundURL!)
    } catch {
      print(error)
    }
    
    
    
    do {
      try session.setCategory(.playAndRecord,options: [.defaultToSpeaker,.allowBluetoothA2DP,.allowBluetooth,.allowAirPlay])
      
    
      
      let output = session.currentRoute.outputs[0].portType
      if output.rawValue == "Speaker"{
        try session.overrideOutputAudioPort(.speaker)
      }
      else{
        try session.overrideOutputAudioPort(.none)
      }
      print("Voice Out \(output)" )
    }
    catch{
      print(error.localizedDescription)
    }
  }

    // Methods
    func playAudioFile() {
  
      audioFile?.play()
      
    }
  
  
  func stopAudioFile() {
    audioFile?.stop()
  }
  
  @objc dynamic private func audioRouteChangeListener(notification:NSNotification) {
      let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt

      switch audioRouteChangeReason {
      case AVAudioSession.RouteChangeReason.newDeviceAvailable.rawValue:
          print("headphone plugged in")
      case AVAudioSession.RouteChangeReason.oldDeviceUnavailable.rawValue:
          print("headphone pulled out")
      
      default:
          break
      }
  }

}
