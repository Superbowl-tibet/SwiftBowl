//
//  SwipeDetectionViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

final class SwipeDetectionViewController: UIViewController, IBInstantiatable {
    
    // MARK: -
    @IBOutlet private weak var detectionView: SwipeDetectionView! {
        didSet {
            self.detectionView.delegate = self
            
            TouchEventDetectionView.init(coder: NSCoder())
        }
    }
    @IBOutlet private weak var circleView: UIView! {
        didSet {
            self.circleView.layer.borderColor = UIColor.white.cgColor
            self.circleView.layer.borderWidth = 1.0
            self.circleView.isHidden = !self.isDebug
        }
    }
    
    private var swipeEvents: [SwipeEvent] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.circleView.isHidden = true
    }
    
    // MARK: -
    private func calculateCircleCenter(p1: CGPoint, p2: CGPoint, p3: CGPoint) -> CGPoint? {
        
        let m0 = p2.y * p1.x
            - p1.y * p2.x
            + p3.y * p2.x
            - p2.y * p3.x
            + p1.y * p3.x
            - p3.y * p1.x
        
        let x = ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.y - p3.y)
            + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.y - p1.y)
            + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.y - p2.y))
            / (m0 * 2.0)
        
        let y = 0
            - ((pow(p1.x, 2) + pow(p1.y, 2)) * (p2.x - p3.x)
                + (pow(p2.x, 2) + pow(p2.y, 2)) * (p3.x - p1.x)
                + (pow(p3.x, 2) + pow(p3.y, 2)) * (p1.x - p2.x))
            / (m0 * 2.0)
        
        guard x.isNaN == false,
            y.isNaN == false,
            x.isInfinite == false,
            y.isInfinite == false
            else {
                return nil
        }
        return CGPoint(x: x, y: y)
    }
    
    private func convertTouchParameters(touch: UITouch) -> SwipeEvent {
        
        let point = touch.location(in: detectionView)
        let now = Date()
        let force: CGFloat?
        let velocity: CGFloat
        var centerPoint: CGPoint? = nil
        var radius: CGFloat? = nil

        if let lastPoint = self.swipeEvents.last {
            
            let interval = now.timeIntervalSince(lastPoint.touchedAt)
            let distance = (point - lastPoint.location).length
            
            velocity = distance / CGFloat(interval)

        } else {
            velocity = 0.0
        }
        
        if self.traitCollection.forceTouchCapability == .available {
            force = touch.force
        } else {
            force = nil
        }
        
        let p2Index = self.swipeEvents.count - self.circleCalculationInterval
        let p1Index = self.swipeEvents.count - (self.circleCalculationInterval * 2)
        
        self.circleView.isHidden = true
        if p1Index >= 0 {
            let p1 = self.swipeEvents[p1Index]
            let p2 = self.swipeEvents[p2Index]

            if let center = self.calculateCircleCenter(p1: p1.location, p2: p2.location, p3: point) {
                
                radius = (center - p1.location).length
                centerPoint = center
                
                if self.isDebug {
                    
                    let diameter = radius! * 2.0
                    self.circleView.isHidden = false
                    self.circleView.frame.size = CGSize(width: diameter, height: diameter)
                    self.circleView.layer.cornerRadius = radius!
                    self.circleView.center = center
                }
            }
        }

        return SwipeEvent(location: point, force: force, touchedAt: now, velocity: velocity, circleCenterPoint: centerPoint, radius: radius)
    }
    
    fileprivate func addTouch(touch: UITouch) {
        
        let swipeEvent = self.convertTouchParameters(touch: touch)
        
        self.swipeEvents.append(swipeEvent)
        self.delegate?.swipeDetectionViewController(controller: self, didUpdateEvent: swipeEvent)
    }
    
    fileprivate func touchEnded(touch: UITouch) {
        
        let swipeEvent = self.convertTouchParameters(touch: touch)
        
        self.swipeEvents.append(swipeEvent)
        self.delegate?.swipeDetectionViewController(controller: self, didUpdateEvent: swipeEvent)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            let zeroVelocityPoint = SwipeEvent.zero(location: swipeEvent.location, touchedAt: Date())
            
            self.swipeEvents.append(zeroVelocityPoint)
            self.delegate?.swipeDetectionViewController(controller: self, didUpdateEvent: zeroVelocityPoint)
            
            self.circleView.isHidden = true
            self.swipeEvents = []
        }
    }
}

extension SwipeDetectionViewController: SwipeDetectionViewDelegate {
    func swipeDetectionView(detectionView: SwipeDetectionView, didUpdateTouch touch: UITouch) {
        self.addTouch(touch: touch)
    }
    
    func swipeDetectionView(detectionView: SwipeDetectionView, didEndTouch touch: UITouch) {
        self.touchEnded(touch: touch)
    }
}
