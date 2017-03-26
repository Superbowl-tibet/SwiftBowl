//
//  SwipeDetectionDemoViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/25.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

class SwipeDetectionDemoViewController: UIViewController {
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    
    private var contentViewController: SwipeDetectionViewController!

    private let audioEngine = SuperBowlAudioEngine()
    private var audioParameter = SuperBowlAudioEngine.AudioParameter(highToneVolume: 0.0, lowToneVolume: 0.0)
    private var audioParameterTimer: Timer?
    private var attenuationRate: Float = 0.95
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.audioEngine.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.audioParameterTimer?.invalidate()
        self.audioEngine.stop()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: -
    private func startTimer() {
        
        self.audioParameterTimer?.invalidate()
        self.audioParameterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateParameter(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateParameter(timer: Timer!) {
        
        let zeroLimit: Float = 0.001
        
        if self.audioParameter.highToneVolume < zeroLimit {
            self.audioParameter.highToneVolume = 0.0
        }
        if self.audioParameter.lowToneVolume < zeroLimit {
            self.audioParameter.lowToneVolume = 0.0
        }
        
        self.audioParameter.highToneVolume *= self.attenuationRate
        self.audioParameter.lowToneVolume *= self.attenuationRate
        
        self.audioEngine.set(parameter: self.audioParameter)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "SwipeDetectionView":
            self.contentViewController = segue.destination as! SwipeDetectionViewController
            self.contentViewController.delegate = self
            
        default:
            fatalError("segue.identifierが設定されていません")
        }
    }
    
    fileprivate func updateTouch(_ touch: SwipeDetectionViewController.TouchPoint) {
        
        if touch.velocity > 0.0 {
            // velocityは高低音の割合を決めて、そこに全体の音量を掛け算して最終的な音量を決める
            // 速度50(下限): low: 0.95, high: 0.1
            // 速度450(上限): low: 0.55, high: 0.9
            
            let lowerLimit: Float = 50.0
            let upperLimit: Float = 450.0
            let range = upperLimit - lowerLimit
            let velocity = min(upperLimit, max(lowerLimit, Float(touch.velocity)))
            let highToneVolume = ((velocity - lowerLimit) / range) * 0.8 + 0.1
            
            self.audioParameter.highToneVolume = highToneVolume
            self.audioParameter.lowToneVolume = (1.0 - highToneVolume) / 2.0 + 0.5  // 0.1 ~ 0.9の範囲だと低音がほぼ聞こえなかったので補強
            
            print(String(format: "v: %.1f, high: %.3f", touch.velocity, highToneVolume))
        }
        
        self.audioEngine.set(parameter: self.audioParameter)
        self.startTimer()
    }
}

extension SwipeDetectionDemoViewController: SwipeDetectionViewControllerDelegate {
    func swipeDetectionViewController(controller: SwipeDetectionViewController, didUpdateTouch touch: SwipeDetectionViewController.TouchPoint) {
        
        let pressureValue: String
        if let force = touch.force {
            pressureValue = String(format: "%.1f", force)
        } else {
            pressureValue = "測定不可"
        }
        
        var message = String(format: "速度\n%.1f\n\n圧力\n", touch.velocity) + pressureValue
        if let center = touch.circleCenterPoint,
            let radius = touch.radius {
            message += String(format: "\n\n中心点\n(%.1f, %.1f)\n\n半径\n%.1f", center.x, center.y, radius)
        }
        self.statusLabel.text = message
        
        self.updateTouch(touch)
    }
}
