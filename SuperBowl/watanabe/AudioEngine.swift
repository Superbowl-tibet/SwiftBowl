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
    
    // 音を変化させるパラメータとして (0..1)
    var speed: Float { get set }
    
    // 端末のパートを表現する数値 (0..n)
    var channel: Int { get set }
    
}

class AudioEngineMock: AudioEngine {
    
    func play() { print(#function) }
    func stop() { print(#function) }
    
    var speed: Float {
        get {
            print(#function)
            return 0
        }
        set {
            print(#function, newValue)
        }
    }
    var channel: Int {
        get {
            print(#function)
            return 0
        }
        set {
            print(#function, newValue)
        }
    }
    
}
