//
//  EnginCore.swift
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import Foundation
import AVFoundation

class SuperBowlAudioEngine: AudioEngine {
    
    private lazy var player: AVAudioPlayer = {
        let url = Bundle.main.url(forResource: "sample", withExtension: "wav")
        let player = try! AVAudioPlayer.init(contentsOf: url!)
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
    var channel: Int {
        get {
            return 0
        }
        set {
            
        }
    }

}
