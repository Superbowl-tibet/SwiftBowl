//
//  CircleView.swift
//  CircleView
//
//  Created by HASHIMOTO Wataru on 2017/03/04.
//  Copyright © 2017年 info.wataruhash. All rights reserved.
//

import UIKit
import Foundation

// speed radian/sec

protocol CircleViewDelegate {
    func circleSpeedDidUpdate(circleView: CircleView,
                              didUpdate speed: Double,
                              currentLocation: CGPoint) -> Void
}

class CircleView: UIView {
    var delegate: CircleViewDelegate?
    
    let stokeColor: UIColor = UIColor.green
    
    var good: Double = 0.0 // 0.0-1.0
        {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func color(good: Double) -> UIColor {
        let normalized: Double
        if good > 1.0 {
            normalized = 1.0
        }
        else if good < 0.0 {
            normalized = 0.0
        }
        else {
            normalized = good
        }
        
        return UIColor(white: CGFloat(normalized), alpha: 1.0)
    }
    
    var lineWidth: CGFloat = 4.0
    
    let areas: [CGRect] = []
    
    var circleFrame: CGRect {
        let shorter = min(self.bounds.width, self.bounds.height)

        let origin = CGPoint(x: (self.bounds.width - shorter) / 2.0,
                             y: (self.bounds.height - shorter) / 2.0)
        let size = CGSize(width: shorter, height: shorter)
        return CGRect(origin: origin,
                      size: size)
    }
    
    func cursorLocationWith(tapped location: CGPoint) -> CGPoint {
        let locationX: CGFloat = location.x - self.circleFrame.midX
        let locationY: CGFloat = location.y - self.circleFrame.midY
        let radian = atan2(-locationX, locationY) + (CGFloat.pi / 2.0)
        
        let radius = self.circleFrame.radius
        let cursorLocation = CGPoint(x: (cos(radian) * radius) + self.circleFrame.midX,
                                     y: (sin(radian) * radius) + self.circleFrame.midY)
        return cursorLocation
    }
    
    func setup() {
        self.clipsToBounds = false
        self.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func trackUserInteraction(at location: CGPoint) {
        print(location)
        
        #if true
            do {
                let up:Double = 0.01
                self.good += up
                print(self.good)
            }
        #endif
        
        self.delegate?.circleSpeedDidUpdate(circleView: self,
                                            didUpdate: 0,
                                            currentLocation: location)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        #if true
        do { // for demo
            context.saveGState()
            context.addEllipse(in: self.circleFrame.insetBy(dx: self.lineWidth,
                                                            dy: self.lineWidth))
            
            let fillColor = self.color(good: self.good).cgColor
            print("fill color: \(fillColor)")
            context.addEllipse(in: self.circleFrame)
            context.setFillColor(fillColor)
            context.fillPath()
            
            context.restoreGState()
        }
        #endif
        
        context.saveGState()
        
        context.addEllipse(in: self.circleFrame.insetBy(dx: (self.lineWidth / 2.0),
                                                        dy: (self.lineWidth / 2.0)))
        context.setStrokeColor(self.stokeColor.cgColor)
        context.setLineWidth(self.lineWidth)
        context.strokePath()
        
        context.restoreGState()
    }
    
    //MARK: - handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        self.trackUserInteraction(at: location)
    }
}
