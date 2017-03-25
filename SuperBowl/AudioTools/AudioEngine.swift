//
//  AudioEngine.swift
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import Foundation

protocol AudioEngine: class {
    
    /// サウンドの再生を開始する。
    func play()
    
    /// サウンドの再生を終了する。
    func stop()
    
    /// 高音トラックの音量プロパティ。有効な値の範囲は0~1。
    var highToneVolume: Float { get set }
    /// 低音トラックの音量プロパティ。有効な値の範囲は0~1。
    var lowToneVolume: Float { get set }
    
    /// 音を変化させるパラメータとして (0..1)
    @available(*, deprecated, message: "")
    var speed: Float { get set }
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
}
