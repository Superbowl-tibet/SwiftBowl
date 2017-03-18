//
//  AudioEngine.swift
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import Foundation

protocol AudioEngine: class {
    
    // 起動後テキトーに呼んでください。重複呼び出しがなければ良いです。
    func play()
    func stop()
    
    
    var highToneVolume: Float { get set }
    var lowToneVolume: Float { get set }
    
    // 音を変化させるパラメータとして (0..1)
    @available(*, deprecated, message: "")
    var speed: Float { get set }
    
    // 端末のパートを表現する数値 (0..n)
    @available(*, deprecated, message: "")
    var sound: Sound { get set }
    
}

class AudioEngineMock: AudioEngine {
    
    func play() { print(#function) }
    func stop() { print(#function) }
    
    var highToneVolume: Float {
        get {
            print(#function)
            return 0
        }
        set {
            print(#function, newValue)
        }
    }
    var lowToneVolume: Float {
        get {
            print(#function)
            return 0
        }
        set {
            print(#function, newValue)
        }
    }
    
    var speed: Float {
        get {
            print(#function)
            return 0
        }
        set {
            print(#function, newValue)
        }
    }
    var sound: Sound {
        get {
            print(#function)
            return .part1
        }
        set {
            print(#function, newValue)
        }
    }
}
