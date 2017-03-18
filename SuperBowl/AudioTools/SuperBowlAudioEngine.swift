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
    case part1 = "sample-1"
    case part2 = "sample-2"
    case part3 = "sample-3"
}

class SuperBowlAudioEngine: AudioEngine {
    
    private let audioEngine = SBTAudioEngine()
    private let hightTonePartA = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-1", withExtension: "aif")!)!
    private let hightTonePartB = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-1", withExtension: "aif")!)!
    private let lowTonePartA = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-2", withExtension: "aif")!)!
    private let lowTonePartB = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-2", withExtension: "aif")!)!
    init() {
        self.audioEngine.add(self.hightTonePartA)
        self.audioEngine.setGain(0, gain: 0)
        
        ExtAudioFileSeek(self.hightTonePartB.audioFile.extAudioFile, self.hightTonePartB.audioFile.totalFrames / 2);
        self.audioEngine.add(self.hightTonePartB)
        self.audioEngine.setGain(1, gain: 0)
        
        self.audioEngine.add(self.lowTonePartA)
        self.audioEngine.setGain(2, gain: 0)
        
        ExtAudioFileSeek(self.lowTonePartB.audioFile.extAudioFile, self.lowTonePartB.audioFile.totalFrames / 2);
        self.audioEngine.add(self.lowTonePartB)
        self.audioEngine.setGain(3, gain: 0)
    }
    
    func play() {
        self.audioEngine.startGraph()
    }
    
    func stop() {
        self.audioEngine.stopGraph()
    }
    
    var heightToneVolume: Float = 0 {
        didSet {
            self.audioEngine.setGain(0, gain: self.heightToneVolume)
            self.audioEngine.setGain(1, gain: self.heightToneVolume)
        }
    }
    var lowToneVolume: Float = 0 {
        didSet {
            self.audioEngine.setGain(2, gain: self.heightToneVolume)
            self.audioEngine.setGain(3, gain: self.heightToneVolume)
        }
    }
    
    @available(*, deprecated, message: "")
    var speed: Float = 0
    
    // 端末のパートを表現する数値 (0..n)
    @available(*, deprecated, message: "")
    var sound: Sound = .part1
}
