//
//  SwipeDetectionView.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

protocol TouchEventDetectionViewDelegate: class {
    func touchEventDetectionView(detectionView: TouchEventDetectionView, didUpdateEvent eventData: TouchEventDetectionView.TouchData)
}

/**
 * 時系列のスワイプイベントを取得するView
 *
 * # コーディング
 * このクラスでは明示的なselfを記述していない
 * 明示的にinit関数を記述している：Xcode上でコード補完とJump to Definitionが誤作動せず便利なので
 */
final class TouchEventDetectionView: UIView {

    typealias TouchData = (location: CGPoint, force: CGFloat?, date: Date, isEndTouch: Bool)
    
    // MARK: - Public Interfaces
    weak var delegate: TouchEventDetectionViewDelegate?
    
    // MARK: - UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, isEndTouch: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, isEndTouch: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, isEndTouch: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches, isEndTouch: true)
    }
    
    // MARK: -
    func handleTouches(_ touches: Set<UITouch>, isEndTouch: Bool) {
        guard let touch = touches.first else {
            return
        }

        let force: CGFloat?
        if self.traitCollection.forceTouchCapability == .available {
            force = touch.force
        } else {
            force = nil
        }
        
        let data = (location: touch.location(in: self), force: force, date: Date(), isEndTouch: isEndTouch)
        delegate?.touchEventDetectionView(detectionView: self, didUpdateEvent: data)
    }
}
