//
//  EnginCore.swift
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import Foundation
import AVFoundation

enum Sound: String {
    case synth = "sample-1"
    case wave = "sample-2"
//    case drum = "sample-3"
}

class SuperBowlAudioEngine: AudioEngine {
    
    private lazy var player: AVAudioPlayer = {
        let fileName = self.sound.rawValue
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        let player = try! AVAudioPlayer.init(contentsOf: url!)
        player.prepareToPlay()
        player.numberOfLoops = -1
        return player 
    }()
    
    func play() {
        self.player.play()
    }
    
    func stop() {
        self.player.stop()
    }
    
    var speed: Float {
        get {
            return self.player.volume
        }
        set {
            self.player.volume = newValue
        }
    }
    
    // 端末のパートを表現する数値 (0..n)
    var channel: Int = 0
    var sound: Sound = .wave
}
