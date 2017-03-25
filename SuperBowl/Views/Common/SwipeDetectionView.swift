//
//  SwipeDetectionView.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

protocol SwipeDetectionViewDelegate: class {
    func swipeDetectionView(detectionView: SwipeDetectionView, didUpdateTouch touch: UITouch)
}

class SwipeDetectionView: UIView {

    weak var delegate: SwipeDetectionViewDelegate?
    
    // MARK: - UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        self.delegate?.swipeDetectionView(detectionView: self, didUpdateTouch: touch) // TODO: velocityが途切れる処理を実装する
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        self.delegate?.swipeDetectionView(detectionView: self, didUpdateTouch: touch)
    }
}
