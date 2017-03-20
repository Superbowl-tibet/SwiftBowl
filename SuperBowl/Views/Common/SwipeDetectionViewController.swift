//
//  SwipeDetectionViewController.swift
//  SuperBowl
//
//  Created by mitsuyoshi.yamazaki on 2017/03/20.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

final class SwipeDetectionViewController: UIViewController, IBInstantiatable {

    struct TouchPoint {
        let location: CGPoint
        let tappedAt: Date
        let velocity: CGFloat
        let circleCenterPoint: CGPoint?
        let radius: CGFloat?
    }

    @IBOutlet private weak var detectionView: SwipeDetectionView! {
        didSet {
            self.detectionView.delegate = self
        }
    }
    @IBOutlet private weak var circleView: UIView! {
        didSet {
            self.circleView.layer.borderColor = UIColor.white.cgColor
            self.circleView.layer.borderWidth = 1.0
            self.circleView.isHidden = true
        }
    }
    
    private var touchPoints: [TouchPoint] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    fileprivate func addTouch(point: CGPoint) {
        // TODO: 古いtouchPointを削除する処理を入れたい
        
        let now = Date()
        
        let p3: TouchPoint
        
        let interval = 30
        let p2Index = self.touchPoints.count - interval
        let p1Index = self.touchPoints.count - (interval * 2)
        
        if p2Index >= 0 {
            
            let p2 = self.touchPoints[p2Index]
            let interval = now.timeIntervalSince(p2.tappedAt)
            let distance = (point - p2.location).length
            let velocity = distance / CGFloat(interval)
            var centerPoint: CGPoint? = nil
            var radius: CGFloat? = nil
            
            if p1Index >= 0 {
                let p1 = self.touchPoints[p1Index]
                
                if let c = self.calculateCircleCenter(p1: p1.location, p2: p2.location, p3: point) {
                    
                    radius = sqrt(pow(c.x-p1.location.x,2)+pow(c.y-p1.location.y,2))
                    centerPoint = c
                    
                    let diameter = radius! * 2.0
                    self.circleView.isHidden = false
                    self.circleView.frame.size = CGSize(width: diameter, height: diameter)
                    self.circleView.layer.cornerRadius = radius!
                    self.circleView.center = c
                }
            }
            
            p3 = TouchPoint(location: point, tappedAt: now, velocity: velocity, circleCenterPoint: centerPoint, radius: radius)
            
        } else {
            p3 = TouchPoint(location: point, tappedAt: now, velocity: 0.0, circleCenterPoint: nil, radius: nil)
        }
        
        self.touchPoints.append(p3)
        print(p3)
    }
}

extension SwipeDetectionViewController: SwipeDetectionViewDelegate {
    func swipeDetectionView(detectionView: SwipeDetectionView, didUpdateTouch touch: UITouch) {
        
        let point = touch.location(in: detectionView)
        self.addTouch(point: point)
    }
}
