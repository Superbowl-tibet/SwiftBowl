//
//  SwipeDetectionView.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

protocol TouchEventDetectionViewDelegate: class {
    func touchEventDetectionView<Event>(detectionView: TouchEventDetectionView<Event>, didUpdateEvent: Event)
}

/**
 * 時系列のスワイプイベントを取得するView
 *
 * # コーディング
 * このクラスでは明示的なselfを記述していない
 */
class TouchEventDetectionView<Event>: UIView {

    typealias TouchData = (touch: UITouch, date: Date, isEndTouch: Bool)
    
    // MARK: - Public Interfaces
    weak var delegate: TouchEventDetectionViewDelegate?
    
    // MARK: - Private Accessor
    private let eventConverter: ([TouchData]) -> Event
    private var touchDataHistory: [TouchData] = [] {
        didSet {
            if let delegate = delegate {
                let event = eventConverter(touchDataHistory)
                delegate.touchEventDetectionView(detectionView: self, didUpdateEvent: event)
            }
        }
    }
    
    // MARK: - Lifecycle
    init(frame: CGRect, converter: @escaping ([TouchData]) -> Event) {
        eventConverter = converter
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required override init(frame: CGRect) {
        fatalError("init(frame:, converter:) を使ってください")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(frame:, converter:) を使ってください")
    }
    
    // MARK: - UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesAdded(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesAdded(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches)
    }
    
    // MARK: -
    func touchesAdded(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        touchDataHistory.append((touch: touch, date: Date(), isEndTouch: false))
    }
    
    func touchesEnded(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        touchDataHistory.append((touch: touch, date: Date(), isEndTouch: true))
    }
}
