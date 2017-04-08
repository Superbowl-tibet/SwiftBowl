//
//  SwipeDetectionDemoViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/25.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

/**
 * TouchEventDetectionViewを使用したスワイプイベントの取得 & 取得した値のAudioEngineへの接続 デモ用
 *
 * # コーディング
 * このクラスでは明示的なselfを記述していない
 * 明示的にinit関数を記述している：Xcode上でコード補完とJump to Definitionが誤作動せず便利なので
 */
final class SwipeDetectionDemoViewController: UIViewController {
    
    struct SwipeEvent {
        let location: CGPoint
        let force: CGFloat?
        let velocity: CGFloat
        let circleCenterPoint: CGPoint?
        let radius: CGFloat?
        
        static var zero: SwipeEvent {
            return self.init(location: CGPoint.zero, force: nil, velocity: 0.0, circleCenterPoint: nil, radius: nil)
        }
    }
    
    @IBOutlet fileprivate weak var statusLabel: UILabel!
    @IBOutlet fileprivate weak var backButton: UIButton!
    
    private let swipeDetectionView: TouchEventDetectionView = {
        
        let view = TouchEventDetectionView.init()
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        return view
    }()
    
    fileprivate let circleView: UIView = {
        
        let view = UIView.init()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = []
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.0
        view.isHidden = true
        
        return view
    }()

    fileprivate let eventConverter = SwipeEventConverter.init()

    private let audioEngine = SuperBowlAudioEngine.init()
    private var audioParameter = SuperBowlAudioEngine.AudioParameter.init(highToneVolume: 0.0, lowToneVolume: 0.0)
    private var audioParameterUpdateTimer: Timer?
    private let audioUpdateInterval: TimeInterval = 0.1
    
    fileprivate var eventHistory: [SwipeEvent] = []
    
    private var attenuationRate: Float = 0.95   // volumeの減衰率
    private var volume: Float = 0.0
    private var highToneVolumeRate: Float = 0.5
    private var lowToneVolumeRate: Float {
        return (1.0 - highToneVolumeRate) / 2.0 + 0.5  // 0.1 ~ 0.9の範囲だと低音がほぼ聞こえなかったので補強している
    }
    private var centerPointList: [CGPoint] = []
    private var radiusList: [CGFloat] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeDetectionView.delegate = self
        swipeDetectionView.frame = view.bounds
        view.addSubview(swipeDetectionView)
        view.addSubview(circleView)
        
        view.bringSubview(toFront: backButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        audioEngine.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        audioParameterUpdateTimer?.invalidate()
        audioEngine.stop()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: -
    private func startTimer() {
        
        audioParameterUpdateTimer?.invalidate()
        audioParameterUpdateTimer = Timer.scheduledTimer(timeInterval: audioUpdateInterval, target: self, selector: #selector(updateParameter(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func updateParameter(timer: Timer!) {
        
        let zeroLimit: Float = 0.001
        
        volume *= attenuationRate
        
        if volume < zeroLimit {
            volume = 0.0
        }
        
        updateParameterOnAudioEngine()
    }
    
    private func updateParameterOnAudioEngine() {
        
        audioParameter.highToneVolume = highToneVolumeRate * volume
        audioParameter.lowToneVolume = lowToneVolumeRate * volume
        
        audioEngine.set(parameter: audioParameter)
    }
    
    fileprivate func updateEvent(_ event: SwipeEvent) {
        
        if event.velocity > 0.0 {
            // velocityは高低音の割合を決めて、そこに全体の音量を掛け算して最終的な音量を決める
            // 速度50(下限): low: 0.95, high: 0.1
            // 速度450(上限): low: 0.55, high: 0.9
            
            let lowerLimit: Float = 50.0
            let upperLimit: Float = 450.0
            let range = upperLimit - lowerLimit
            let velocity = min(upperLimit, max(lowerLimit, Float(event.velocity)))
            
            highToneVolumeRate = ((velocity - lowerLimit) / range) * 0.8 + 0.1
            
        } else {

            centerPointList = []
            radiusList = []
        }
        
        //volumeの更新処理入れる
        if volume < 0.05 {
            volume = 0.05
        }
        
        if let previousRadius = eventHistory.last?.radius
            , let radius = event.radius {

            let radiusDiff = abs(radius - previousRadius) / radius  // 半径の差が小さいほど良い
            let volumeIncreaseRate: Float = 1.01 * (1.0 - Float(radiusDiff))
            volume *= max(volumeIncreaseRate, 0.95)
            
            if volume > 1.0 {
                volume = 1.0
            }
        }
        
        eventHistory.append(event)
        updateParameterOnAudioEngine()
        startTimer()
    }
}

extension SwipeDetectionDemoViewController: TouchEventDetectionViewDelegate {
    func touchEventDetectionView(detectionView: TouchEventDetectionView, didUpdateEvent eventData: TouchEventDetectionView.TouchData) {
        
        let event = eventConverter.convert(touchData: eventData)
        
        let pressureValue: String
        if let force = event.force {
            pressureValue = String.init(format: "%.1f", force)
        } else {
            pressureValue = "測定不可"
        }
        
        var message = String.init(format: "速度\n%.1f\n\n圧力\n", event.velocity) + pressureValue
        if let center = event.circleCenterPoint,
            let radius = event.radius {
            
            message += String.init(format: "\n\n中心点\n(%.1f, %.1f)\n\n半径\n%.1f", center.x, center.y, radius)
            
            let diameter = radius * 2.0
            circleView.frame.size = CGSize.init(width: diameter, height: diameter)
            circleView.layer.cornerRadius = radius
            circleView.center = center
            circleView.isHidden = false
            
        } else {
            circleView.isHidden = true
        }
        
        statusLabel.text = message
        
        if eventData.isEndTouch {
            
            eventHistory = []
            circleView.isHidden = true
            statusLabel.isHidden = true
        } else {
            statusLabel.isHidden = false
        }
        
        updateEvent(event)
    }
}

// MARK: - Swipe Event Converter
final class SwipeEventConverter {

    private var history: [TouchEventDetectionView.TouchData] = []
    
    func convert(touchData: TouchEventDetectionView.TouchData) -> SwipeDetectionDemoViewController.SwipeEvent {
        
        /// スワイプ経路の3点から円の中心を算出するが、その3点を選択する際にどれだけ過去にさかのぼるかを決定するパラメータ
        /// 小さくすると直近のノイズに弱くなり、大きくすると安定するが過去のノイズに弱くなる
        let circleCalculationInterval = 30
        
        let point = touchData.location
        let velocity: CGFloat
        var centerPoint: CGPoint? = nil
        var radius: CGFloat? = nil
        
        if let previousData = history.last {
            let previousPoint = previousData.location
            let interval = touchData.date.timeIntervalSince(previousData.date)
            let distance = (point - previousPoint).length
            
            velocity = distance / CGFloat(interval)

        } else {
            velocity = 0.0
        }
        
        let data2Index = history.count - circleCalculationInterval
        let data1Index = history.count - (circleCalculationInterval * 2)
        
        if data1Index >= 0 {
            let data1 = history[data1Index]
            let data2 = history[data2Index]
            
            let point1 = data1.location
            let point2 = data2.location
            
            if let center = CGPoint.calculateCircleCenter(p1: point1, p2: point2, p3: point) {
                
                radius = (center - point1).length
                centerPoint = center
            }
        }
        
        history.append(touchData)
        
        return SwipeDetectionDemoViewController.SwipeEvent(location: point, force: touchData.force, velocity: velocity, circleCenterPoint: centerPoint, radius: radius)
    }
}
