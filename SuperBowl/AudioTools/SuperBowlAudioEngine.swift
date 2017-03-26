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
    
    struct AudioParameter {
        var highToneVolume: Float
        var lowToneVolume: Float
    }
    
    private let audioEngine = SBTAudioEngine()
    private let highTonePartA = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-1", withExtension: "aif")!)!
    private let highTonePartB = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-1", withExtension: "aif")!)!
    private let lowTonePartA = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-2", withExtension: "aif")!)!
    private let lowTonePartB = SBTTrack(audioURL: Bundle.main.url(forResource: "sample-2", withExtension: "aif")!)!
    init() {
        self.audioEngine.add(self.highTonePartA)
        self.audioEngine.setGain(0, gain: 0)
        
        ExtAudioFileSeek(self.highTonePartB.audioFile.extAudioFile, self.highTonePartB.audioFile.totalFrames / 2);
        self.audioEngine.add(self.highTonePartB)
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
    
    var highToneVolume: Float = 0 {
        didSet {
            self.audioEngine.setGain(0, gain: self.highToneVolume)
            self.audioEngine.setGain(1, gain: self.highToneVolume)
        }
    }
    var lowToneVolume: Float = 0 {
        didSet {
            self.audioEngine.setGain(2, gain: self.lowToneVolume)
            self.audioEngine.setGain(3, gain: self.lowToneVolume)
        }
    }
    
    func set(parameter: AudioParameter) {
        self.highToneVolume = parameter.highToneVolume
        self.lowToneVolume = parameter.lowToneVolume
    }
    
    // deprecated
    var speed: Float = 0 {
        didSet {
            self.highToneVolume = self.speed
            self.lowToneVolume = self.speed
        }
    }
}
