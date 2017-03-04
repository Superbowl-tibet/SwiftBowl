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

protocol InteractiveCircleViewDelegate {
    func circleSpeedDidUpdate(circleView: CircleView,
                              didUpdate speed: Double,
                              currentLocation: CGPoint) -> Void
}

class CircleView: UIView {
    var filledBackgroundColor: UIColor?
    
    var stokeColor: UIColor = UIColor.gray
    
    func locationFromCircleCenter(from location: CGPoint) -> CGPoint {
        let locationX: CGFloat = location.x - self.circleFrame.midX
        let locationY: CGFloat = location.y - self.circleFrame.midY
        let radian = atan2(-locationX, locationY) + (CGFloat.pi / 2.0)
        
        let radius = self.circleFrame.radius
        let cursorLocation = CGPoint(x: (cos(radian) * radius),
                                     y: (sin(radian) * radius))
        return cursorLocation
    }

    var good: Double = 0.0 // 0.0-1.0
        {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func color(good: Double) -> UIColor {
        return UIColor.white
        
        #if false
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
        
        return UIColor(white: CGFloat(normalized),
                       alpha: 1.0)
        #endif
    }
    
    var lineWidth: CGFloat = 2.0
    
    public var circleFrame: CGRect {
        let shorter = min(self.bounds.width, self.bounds.height)
        
        let origin = CGPoint(x: (self.bounds.width - shorter) / 2.0,
                             y: (self.bounds.height - shorter) / 2.0)
        let size = CGSize(width: shorter, height: shorter)
        return CGRect(origin: origin,
                      size: size)
    }
    
    public func cursorLocationWith(tapped location: CGPoint) -> CGPoint {
        let fromCircleCenter = locationFromCircleCenter(from: location)
        
        return CGPoint(x: fromCircleCenter.x + self.circleFrame.midX,
                       y: fromCircleCenter.y + self.circleFrame.midY)
    }
    
    private func setup() {
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        do {
            context.saveGState()
            context.setFillColor(UIColor.clear.cgColor)
            context.fill(rect)
            context.restoreGState()
        }
        
        if let circleFillColor = self.filledBackgroundColor?.cgColor {
            context.saveGState()
            context.addEllipse(in: self.circleFrame.insetBy(dx: self.lineWidth,
                                                            dy: self.lineWidth))
            
            let fillColor = circleFillColor
            context.addEllipse(in: self.circleFrame)
            context.setFillColor(fillColor)
            context.fillPath()
            
            context.restoreGState()
        }
        
        do {
            context.saveGState()
            context.addEllipse(in: self.circleFrame.insetBy(dx: self.lineWidth,
                                                            dy: self.lineWidth))
            
            let fillColor = self.color(good: self.good).cgColor
            context.addEllipse(in: self.circleFrame)
            context.setFillColor(fillColor)
            context.fillPath()
            
            context.restoreGState()
        }
        
        context.saveGState()
        
        context.addEllipse(in: self.circleFrame.insetBy(dx: (self.lineWidth / 2.0),
                                                        dy: (self.lineWidth / 2.0)))
        context.setStrokeColor(self.stokeColor.cgColor)
        context.setLineWidth(self.lineWidth)
        context.strokePath()
        
        context.restoreGState()
    }
}

class InteractiveCircleView: CircleView {
    var delegate: InteractiveCircleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.isUserInteractionEnabled = true
    }
    
    private func trackUserInteraction(at location: CGPoint) {
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

    //MARK: - handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        self.trackUserInteraction(at: location)
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

